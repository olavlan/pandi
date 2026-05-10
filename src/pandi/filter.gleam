import gleam/list
import gleam/option.{type Option, None, Some}
import pandi/pandoc as pd

pub type BlockFilter =
  fn(pd.Block, pd.Meta) -> Option(List(pd.Block))

pub type InlineFilter =
  fn(pd.Inline, pd.Meta) -> Option(List(pd.Inline))

pub fn filter_blocks(
  document: pd.Document,
  filter: BlockFilter,
) -> pd.Document {
  let new_blocks = walk_blocks(document.blocks, document.meta, filter)
  pd.Document(..document, blocks: new_blocks)
}

pub fn filter_inlines(
  document: pd.Document,
  filter: InlineFilter,
) -> pd.Document {
  let new_blocks =
    list.map(document.blocks, walk_inlines_in_block(_, document.meta, filter))
  pd.Document(..document, blocks: new_blocks)
}

fn walk_blocks(
  blocks: List(pd.Block),
  meta: pd.Meta,
  filter: BlockFilter,
) -> List(pd.Block) {
  list.flat_map(blocks, fn(block) {
    case filter(block, meta) {
      Some(new_blocks) -> new_blocks
      None -> {
        case block {
          pd.Div(attrs, content) -> [
            pd.Div(attrs, walk_blocks(content, meta, filter)),
          ]
          pd.BulletList(items) -> [
            pd.BulletList(list.map(items, walk_blocks(_, meta, filter))),
          ]
          _ -> [block]
        }
      }
    }
  })
}

fn walk_inlines_in_block(
  block: pd.Block,
  meta: pd.Meta,
  filter: InlineFilter,
) -> pd.Block {
  case block {
    pd.Header(level, attrs, content) ->
      pd.Header(level, attrs, walk_inlines(content, meta, filter))
    pd.Para(content) -> pd.Para(walk_inlines(content, meta, filter))
    pd.Plain(content) -> pd.Plain(walk_inlines(content, meta, filter))
    pd.Div(attrs, content) ->
      pd.Div(attrs, list.map(content, walk_inlines_in_block(_, meta, filter)))
    pd.BulletList(items) ->
      pd.BulletList(
        list.map(items, list.map(_, walk_inlines_in_block(_, meta, filter))),
      )
    _ -> block
  }
}

fn walk_inlines(
  inlines: List(pd.Inline),
  meta: pd.Meta,
  filter: InlineFilter,
) -> List(pd.Inline) {
  list.flat_map(inlines, fn(inline) {
    case filter(inline, meta) {
      Some(new_inlines) -> new_inlines
      None -> {
        case inline {
          pd.Span(attrs, content) -> [
            pd.Span(attrs, walk_inlines(content, meta, filter)),
          ]
          pd.Link(attrs, content, target) -> [
            pd.Link(attrs, walk_inlines(content, meta, filter), target),
          ]
          _ -> [inline]
        }
      }
    }
  })
}
