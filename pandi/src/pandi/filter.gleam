import gleam/list
import pandi/doc

/// A function that takes a block (and document metadata), and returns an action.
///
/// Use `apply_inline_filter` to apply it to a `Document` object.
/// 
/// Examples:
///
/// ```gleam
/// let increase_header_level: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Header(level, _, _) -> 
///       [doc.Header(..block, level: level + 1)] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// ```
///
pub type BlockFilter =
  fn(doc.Block, doc.Meta) -> Action(doc.Block)

/// A function that takes an inline (and the document metadata), and returns an action.
///
/// Use `apply_inline_filter` to apply it to a `Document` object.
/// 
/// Examples:
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

///The type that a filter function must return.
///
///Use the action contructors: `keep`, `remove`, `replace`, `append` and `prepend`.
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
/// Note that the children of the element (if any) will be filtered.
/// If you want to "freeze" the children of an element, use `replace(block)`,
/// where `block` is the element you're matching on.
///
/// This action is typically used to match on remaining elements in a filter function:
/// ```gleam
/// let filter: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     // match and process specific elements, then... 
///     _ -> filter.keep // ...keep the remaining elements
///   }
/// }
pub const keep: Action(element) = Action([], KeepOriginal, [])

/// Action to remove an element.
///
/// Examples:
///
/// Remove paragraphs starting with "//":
/// ```gleam
/// let remove_comment_lines: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Paragraph([doc.Str("//" <> _), ..]) -> filter.remove
///     _ -> filter.keep
///   }
/// }
/// ```
pub const remove: Action(element) = Action([], RemoveOriginal, [])

/// Action to prepend new elements to an element.
///
/// Note that the children of the prepended elements (if any) will **not** be filtered.
/// If you want to process the children of prepended elements, apply a subsequent filter to the document instead.
///
/// Examples:
///
/// Prepending a star to every ocurrence of "Gleam":
/// ```gleam
/// let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("Gleam") -> [doc.Str("⭐️")] |> filter.prepend
///     _ -> filter.keep
///   }
/// }
/// ```
pub fn prepend(elements: List(element)) -> Action(element) {
  Action(elements, KeepOriginal, [])
}

/// Action to append new elements to an element.
///
/// Note that the children of the appended elements (if any) will **not** be filtered.
/// If you want to process the children of appended elements, apply a subsequent filter to the document instead.
///
/// Examples:
///
/// ```gleam
/// let run_code = fn(code: String) -> String { todo }
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

/// Action to replace an element.
///
/// Note that the children of the replacements (if any) will **not** be filtered.
/// If you want to process the children of the replacements, apply a subsequent filter to the document instead.
///
/// This is typically used to modify elements:
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
/// Example:
pub fn apply_block_filter(
  document: doc.Document,
  filter: BlockFilter,
) -> doc.Document {
  let new_blocks = walk_blocks(document.blocks, document.meta, filter)
  doc.Document(..document, blocks: new_blocks)
}

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
