import gleam/list
import pandi as doc

/// A function that takes in a block (and the document metadata), and returns a filter action.
///
/// Example:
///
/// ```gleam
/// let increase_header_level: filter.BlockFilter = fn(block, _meta) {
///   case block {
///     doc.Header(level, _, _) ->
///       filter.remove |> filter.append(doc.Header(..block, level: level + 1))
///     _ -> filter.keep
///   }
/// }
/// ```
///
/// This filter increases the header level of all `Header` elements.
/// Use `filter_blocks` to apply the filter to a `Document` object.
pub type BlockFilter =
  fn(doc.Block, doc.Meta) -> Action(doc.Block)

/// A function that takes in an inline (and the document metadata), and returns a filter action.
///
/// Example:
///
/// ```gleam
/// let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
///   case inline {
///     doc.Str("Gleam") -> filter.keep |> filter.prepend(doc.Str("⭐️"))
///     _ -> filter.keep
///   }
/// }
/// ```
///
/// This filter adds a star in front of every ocurrence of "Gleam" in the document.
/// Use `filter_inlines` to apply the filter to a `Document` object.
pub type InlineFilter =
  fn(doc.Inline, doc.Meta) -> Action(doc.Inline)

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

pub const keep: Action(element) = Action([], KeepOriginal, [])

pub const remove: Action(element) = Action([], RemoveOriginal, [])

pub fn prepend(
  previous_action: Action(element),
  prepend: element,
) -> Action(element) {
  Action(..previous_action, prepend: [prepend, ..previous_action.prepend])
}

pub fn append(
  previous_action: Action(element),
  append: element,
) -> Action(element) {
  Action(
    ..previous_action,
    append: list.append(previous_action.append, [append]),
  )
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
