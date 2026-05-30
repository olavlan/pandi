import gleam/list
import lustre/element as lustre
import lustre/element/html
import pandi/doc

pub fn main() {
  let block_converter: BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(_, content) -> {
        use children <- default_blocks(content)
        use copy <- default_blocks(content)
        html.div([], [children, copy]) |> custom
      }
      _ -> default
    }
  }
}

pub fn default_blocks(
  blocks: List(doc.Block),
  callback: fn(lustre.Element(msg)) -> Element(doc.Block, msg),
) -> Element(doc.Block, msg) {
  WithDefault(blocks, callback)
}

pub fn default_inlines(
  inlines: List(doc.Inline),
  callback: fn(lustre.Element(msg)) -> Element(doc.Inline, msg),
) -> Element(doc.Inline, msg) {
  WithDefault(inlines, callback)
}

pub fn custom(element: lustre.Element(msg)) -> Element(kind, msg) {
  Custom(element)
}

const default: Element(kind, msg) = Default

pub type Element(kind, msg) {
  Custom(element: lustre.Element(msg))
  WithDefault(
    document_elements: List(kind),
    callback: fn(lustre.Element(msg)) -> Element(kind, msg),
  )
  Default
}

pub type BlockConverter(msg) =
  fn(doc.Block, doc.Meta) -> Element(doc.Block, msg)

pub type InlineConverter(msg) =
  fn(doc.Inline, doc.Meta) -> Element(doc.Inline, msg)

pub fn convert_blocks(
  blocks: List(doc.Block),
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(blocks, convert_block(_, block_converter, inline_converter, meta))
  |> lustre.fragment
}

fn convert_block(
  block: doc.Block,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  block_converter(block, meta)
  |> convert_block_element(block, block_converter, inline_converter, meta)
}

fn convert_block_element(
  element: Element(doc.Block, msg),
  original_block: doc.Block,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case element {
    WithDefault(blocks, callback) ->
      convert_blocks(blocks, block_converter, inline_converter, meta)
      |> callback
      |> convert_block_element(
        original_block,
        block_converter,
        inline_converter,
        meta,
      )
    Custom(element) -> element
    Default ->
      case original_block {
        _ -> lustre.none()
      }
  }
}

pub fn convert_inlines(
  inlines: List(doc.Inline),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(inlines, convert_inline(_, inline_converter, meta))
  |> lustre.fragment
}

fn convert_inline(
  inline: doc.Inline,
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  inline_converter(inline, meta)
  |> convert_inline_element(inline, inline_converter, meta)
}

fn convert_inline_element(
  element: Element(doc.Inline, msg),
  original_inline: doc.Inline,
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case element {
    WithDefault(inlines, callback) ->
      convert_inlines(inlines, inline_converter, meta)
      |> callback
      |> convert_inline_element(original_inline, inline_converter, meta)
    Custom(element) -> element
    Default ->
      case original_inline {
        _ -> lustre.none()
      }
  }
}
