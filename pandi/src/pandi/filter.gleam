//// This module aims to make it easy to define *document filters*,
//// i.e. element-processing functions that can be applied the whole document tree.
//// The types guarantee a valid doument at the end; infinite recursion loops will never happen.
////
//// Complete example:
////
//// ```gleam 
//// import gleam/io
//// import pandi/doc
//// import pandi/filter
//// 
//// pub fn main() {
////   let change_ordered_to_bullet_list: filter.BlockFilter = fn(block, _meta) {
////     case block {
////       doc.OrderedList(_, items) -> [doc.BulletList(items)] |> filter.replace
////       _ -> filter.keep
////     }
////   }
//// 
////   let empty_attributes = doc.Attributes(id: "", classes: [], keyvalues: [])
////   let insert_github_links: filter.InlineFilter = fn(inline, _meta) {
////     case inline {
////       doc.Str("gh:" <> repo) ->
////         [
////           doc.Link(
////             attributes: empty_attributes,
////             content: doc.text(repo <> " 🔗"),
////             target: doc.Target(
////               url: "https://github.com/" <> repo,
////               title: repo <> " at Github",
////             ),
////           ),
////         ]
////         |> filter.replace
////       _ -> filter.keep
////     }
////   }
//// 
////   let list_attributes = doc.ListAttributes(1, doc.Decimal, doc.Period)
////   let document =
////     doc.Document(
////       blocks: [
////         doc.OrderedList(list_attributes, [
////           [doc.Plain([doc.Str("gh:lustre-labs/lustre")])],
////           [doc.Plain([doc.Str("gh:gleam-wisp/wisp")])],
////           [doc.Plain([doc.Str("gh:giacomocavalieri/squirrel")])],
////         ]),
////       ],
////       meta: [],
////     )
//// 
////   document
////   |> filter.apply_block_filter(change_ordered_to_bullet_list)
////   |> filter.apply_inline_filter(insert_github_links)
////   |> doc.to_json
////   |> io.println
//// }
//// ```
////
//// Run it with `pandoc`:
////
//// ```sh
//// $ gleam run --no-print-progress | pandoc -f json -t markdown --wrap=preserve
//// - [lustre-labs/lustre 🔗](https://github.com/lustre-labs/lustre "lustre-labs/lustre at Github")
//// - [gleam-wisp/wisp 🔗](https://github.com/gleam-wisp/wisp "gleam-wisp/wisp at Github")
//// - [giacomocavalieri/squirrel 🔗](https://github.com/giacomocavalieri/squirrel "giacomocavalieri/squirrel at Github")
//// ```

import gleam/list
import pandi/doc

/// A function that takes a block (and the document metadata) and returns an action.
///
/// Use `apply_block_filter` to apply it to a document.
/// 
/// Example:
///
/// ```gleam
/// let increase_header_level: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Header(level, ..) -> 
///       [doc.Header(..block, level: level + 1)] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// ```
///
pub type BlockFilter =
  fn(doc.Block, doc.Meta) -> Action(doc.Block)

/// A function that takes an inline (and the document metadata) and returns an action.
///
/// Use `apply_inline_filter` to apply it to a document.
/// 
/// Example:
///
/// ```gleam
/// let capitalize_gleam: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("gleam") -> [doc.Str("Gleam")] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// ```
pub type InlineFilter =
  fn(doc.Inline, doc.Meta) -> Action(doc.Inline)

///The type that a filter function returns.
///
/// Use the provided constructors: `keep`, `remove`, `replace`, `append` and `prepend`.
pub opaque type Action(element) {
  Action(
    prepend: List(element),
    original: OriginalElementAction,
    append: List(element),
  )
}

type OriginalElementAction {
  KeepOriginal
  RemoveOriginal
}

/// Action to keep an element.
///
/// This action is typically used to match on remaining elements in a filter function:
/// ```gleam
/// let filter: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     // match and process specific elements, then... 
///     _ -> filter.keep // ...keep the remaining elements (and filter their children)
///   }
/// }
/// ``` 
///
/// Note that children of the kept element will be filtered recursively.
pub const keep: Action(element) = Action([], KeepOriginal, [])

/// Action to remove an element.
///
/// Example:
///
/// ```gleam
/// let remove_comment_lines: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Para([doc.Str("//" <> _), ..]) -> filter.remove
///     _ -> filter.keep
///   }
/// }
/// ```
pub const remove: Action(element) = Action([], RemoveOriginal, [])

/// Action to prepend new elements to an element.
///
/// Example:
///
/// ```gleam
/// let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("Gleam") -> doc.text("⭐️ ") |> filter.prepend
///     _ -> filter.keep
///   }
/// }
/// ```
pub fn prepend(elements: List(element)) -> Action(element) {
  Action(elements, KeepOriginal, [])
}

/// Action to append new elements to an element.
///
/// Example:
///
/// ```gleam
/// let run_code = fn(code: String) -> String { "mocked code result" }
/// let append_code_result: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.CodeBlock(_, code) ->
///       [doc.Para(doc.text(run_code(code)))] |> filter.append
///     _ -> filter.keep
///   }
/// }
/// ```
pub fn append(elements: List(element)) -> Action(element) {
  Action([], KeepOriginal, elements)
}

/// Action to replace an element with new elements.
///
/// This action is typically used to modify elements:
///
/// ```gleam
/// let inlcude_link_symbol: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Link(_, content, _) ->
///       [doc.Link(..inline, content: list.append(content, doc.text(" 🔗")))]
///       |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// ```
pub fn replace(elements: List(element)) -> Action(element) {
  Action(elements, RemoveOriginal, [])
}

/// Apply a block filter to a document.
///
/// This recursively applies the filter to every block element in the document.
///
/// Example:
/// 
/// ```gleam
/// let attributes = doc.Attributes(id: "", classes: ["gleam"], keyvalues: [])
/// 
/// let wrap_code_blocks_in_div: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.CodeBlock(..) -> [doc.Div(attributes, [block])] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// 
/// doc.Document([doc.CodeBlock(attributes, "pub const pi = 3.14")], [])
/// |> filter.apply_block_filter(wrap_code_blocks_in_div)
/// |> doc.to_string
/// // [
/// //   Div
/// //     ( "" , [ "gleam" ] , [  ] )
/// //     [ CodeBlock ( "" , [ "gleam" ] , [  ] ) "pub const pi = 3.14" ] ,
/// // ]
/// ```
///
/// Note that the children of the inserted div are not filtered,
/// since this would lead to an infinite recursion loop.
/// If you need to further process inserted elements, apply a new filter intead. 
pub fn apply_block_filter(
  document: doc.Document,
  filter: BlockFilter,
) -> doc.Document {
  let new_blocks = walk_blocks(document.blocks, document.meta, filter)
  doc.Document(..document, blocks: new_blocks)
}

/// Apply an inline filter to a document.
///
/// This recursively applies the filter to every inline element in the document.
///
/// Example:
///
/// ```gleam
/// let attributes = doc.Attributes(id: "", classes: ["gleam"], keyvalues: [])
/// 
/// let wrap_gleam_in_span: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("Gleam") -> [doc.Span(attributes, [inline])] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// 
/// doc.Document([doc.Para(doc.text("Gleam is cool!"))], [])
/// |> filter.apply_inline_filter(wrap_gleam_in_span)
/// |> doc.to_string
/// // [
/// //   Para
/// //     [
/// //       Span ( "" , [ "gleam" ] , [  ] ) [ Str "Gleam" ] ,
/// //       Space ,
/// //       Str "is" ,
/// //       Space ,
/// //       Str "cool!" ,
/// //     ] ,
/// // ]
/// ```
/// Note that the children of the inserted span are not filtered,
/// since this would lead to an infinite recursion loop.
/// If you need to further process inserted elements, apply a new filter intead. 
pub fn apply_inline_filter(
  document: doc.Document,
  filter: InlineFilter,
) -> doc.Document {
  let new_blocks =
    list.map(document.blocks, walk_inlines_in_block(_, document.meta, filter))
  doc.Document(..document, blocks: new_blocks)
}

fn walk_blocks(
  blocks: List(doc.Block),
  meta: doc.Meta,
  filter: BlockFilter,
) -> List(doc.Block) {
  list.flat_map(blocks, walk_block(_, meta, filter))
}

fn walk_block(
  block: doc.Block,
  meta: doc.Meta,
  filter: BlockFilter,
) -> List(doc.Block) {
  case filter(block, meta) {
    Action(prepend, RemoveOriginal, append) ->
      [prepend, append]
      |> list.flatten

    Action(prepend, KeepOriginal, append) -> {
      let original_block_with_filtered_children: doc.Block = case block {
        doc.Div(attrs, content) ->
          doc.Div(attrs, walk_blocks(content, meta, filter))
        doc.BulletList(items) ->
          doc.BulletList(list.map(items, walk_blocks(_, meta, filter)))
        doc.OrderedList(list_attributes, items) ->
          doc.OrderedList(
            list_attributes,
            list.map(items, walk_blocks(_, meta, filter)),
          )
        _ -> block
      }
      [prepend, [original_block_with_filtered_children], append] |> list.flatten
    }
  }
}

fn walk_inlines_in_block(
  block: doc.Block,
  meta: doc.Meta,
  filter: InlineFilter,
) -> doc.Block {
  case block {
    doc.Header(level, attrs, content) ->
      doc.Header(level, attrs, walk_inlines(content, meta, filter))
    doc.Para(content) -> doc.Para(walk_inlines(content, meta, filter))
    doc.Plain(content) -> doc.Plain(walk_inlines(content, meta, filter))
    doc.Div(attrs, content) ->
      doc.Div(attrs, list.map(content, walk_inlines_in_block(_, meta, filter)))
    doc.BulletList(items) ->
      doc.BulletList(
        list.map(items, list.map(_, walk_inlines_in_block(_, meta, filter))),
      )
    doc.OrderedList(list_attributes, items) ->
      doc.OrderedList(
        list_attributes,
        list.map(items, list.map(_, walk_inlines_in_block(_, meta, filter))),
      )
    _ -> block
  }
}

fn walk_inlines(
  inlines: List(doc.Inline),
  meta: doc.Meta,
  filter: InlineFilter,
) -> List(doc.Inline) {
  list.flat_map(inlines, walk_inline(_, meta, filter))
}

fn walk_inline(
  inline: doc.Inline,
  meta: doc.Meta,
  filter: InlineFilter,
) -> List(doc.Inline) {
  case filter(inline, meta) {
    Action(prepend, RemoveOriginal, append) ->
      [prepend, append]
      |> list.flatten
    Action(prepend, KeepOriginal, append) -> {
      let original_inline_with_filtered_children: doc.Inline = case inline {
        doc.Emph(content) -> doc.Emph(walk_inlines(content, meta, filter))
        doc.Strong(content) -> doc.Strong(walk_inlines(content, meta, filter))
        doc.Strikeout(content) ->
          doc.Strikeout(walk_inlines(content, meta, filter))
        doc.Span(attrs, content) ->
          doc.Span(attrs, walk_inlines(content, meta, filter))
        doc.Link(attrs, content, target) ->
          doc.Link(attrs, walk_inlines(content, meta, filter), target)
        _ -> inline
      }
      [prepend, [original_inline_with_filtered_children], append]
      |> list.flatten
    }
  }
}
