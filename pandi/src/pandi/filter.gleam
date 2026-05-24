import gleam/list
import pandi/doc

/// A function that takes a block (and document metadata), and returns an action.
///
/// Define filters as in the examples below, and use `filter_blocks` to apply them to a `Document` object.
/// 
/// Examples:
///
/// Note that `pandi` is imported as `doc`.
///
/// ```gleam
/// let increase_header_level: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Header(level, _, _) -> [doc.Header(..block, level: level + 1)] |> filter.replace
///     _ -> filter.keep
///   }
/// }
/// ```
///
pub type BlockFilter =
  fn(doc.Block, doc.Meta) -> Action(doc.Block)

/// A function that takes in an inline (and the document metadata), and returns an action.
///
/// Define filters as in the examples below, and use `filter_blocks` to apply them to a `Document` object.
/// 
/// Examples:
///
/// Note that `pandi` is imported as `doc`.
///
/// Adding a star in front of every ocurrence of "Gleam" in the document:
/// ```gleam
/// let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("Gleam") -> [doc.Str("⭐️")] |> filter.prepend
///     _ -> filter.keep
///   }
/// }
/// ```
pub type InlineFilter =
  fn(doc.Inline, doc.Meta) -> Action(doc.Inline)

///The type that a filter function must return.
///
///Use the action constructors `keep`, `remove`, `replace`, `append` and `prepend`.
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

/// Action to keep an element, but apply the filter function to its children, if any.
///
/// Typically used to match on remaining elements at the end of a filter function.
pub const keep: Action(element) = Action([], KeepOriginal, [])

/// Action to remove an element.
///
/// Examples:
///
/// Note that `pandi` is imported as `doc`.
///
/// Filter that removes paragraphs starting with "//":
/// ```gleam
/// let remove_comment_lines: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Paragraph([doc.Str("//" <> _), ..]) -> filter.remove
///     _ -> filter.keep
///   }
/// }
/// ```
pub const remove: Action(element) = Action([], RemoveOriginal, [])

pub fn prepend(elements: List(element)) -> Action(element) {
  Action(elements, KeepOriginal, [])
}

pub fn append(elements: List(element)) -> Action(element) {
  Action([], KeepOriginal, elements)
}

pub fn replace(elements: List(element)) -> Action(element) {
  Action(elements, RemoveOriginal, [])
}

pub fn filter_blocks(
  document: doc.Document,
  filter: BlockFilter,
) -> doc.Document {
  let new_blocks = walk_blocks(document.blocks, document.meta, filter)
  doc.Document(..document, blocks: new_blocks)
}

pub fn filter_inlines(
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
