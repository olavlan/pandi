import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import pandi/pandoc as pd

pub type BlockRenderer(msg) =
  fn(pd.Block, pd.Meta) -> Option(Element(msg))

pub type InlineRenderer(msg) =
  fn(pd.Inline, pd.Meta) -> Option(Element(msg))

pub fn to_lustre(document: pd.Document) -> Element(msg) {
  blocks_to_lustre(document.blocks)
}

pub fn blocks_to_lustre(blocks: List(pd.Block)) -> Element(msg) {
  let elements = list.map(blocks, block_to_lustre)
  element.fragment(elements)
}

pub fn block_to_lustre(block: pd.Block) -> Element(msg) {
  block_to_lustre_with(block, fn(_, _) { None }, fn(_, _) { None }, [])
}

pub fn inlines_to_lustre(inlines: List(pd.Inline)) -> Element(msg) {
  let elements = list.map(inlines, inline_to_lustre)
  element.fragment(elements)
}

pub fn inline_to_lustre(inline: pd.Inline) -> Element(msg) {
  inline_to_lustre_with(inline, fn(_, _) { None }, [])
}

pub fn to_lustre_with(
  document: pd.Document,
  block_renderer: BlockRenderer(msg),
  inline_renderer: InlineRenderer(msg),
) -> Element(msg) {
  blocks_to_lustre_with(
    document.blocks,
    block_renderer,
    inline_renderer,
    document.meta,
  )
}

pub fn blocks_to_lustre_with(
  blocks: List(pd.Block),
  block_renderer: BlockRenderer(msg),
  inline_renderer: InlineRenderer(msg),
  meta: pd.Meta,
) -> Element(msg) {
  let elements =
    list.map(blocks, block_to_lustre_with(
      _,
      block_renderer,
      inline_renderer,
      meta,
    ))
  element.fragment(elements)
}

pub fn inlines_to_lustre_with(
  inlines: List(pd.Inline),
  inline_remderer: InlineRenderer(msg),
  meta: pd.Meta,
) -> Element(msg) {
  let elements =
    list.map(inlines, inline_to_lustre_with(_, inline_remderer, meta))
  element.fragment(elements)
}

fn block_to_lustre_with(
  block: pd.Block,
  block_renderer: BlockRenderer(msg),
  inline_renderer: InlineRenderer(msg),
  meta: pd.Meta,
) -> Element(msg) {
  case block_renderer(block, meta) {
    Some(el) -> el
    None ->
      case block {
        pd.Header(level, attrs, content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          let attrs = attributes_to_lustre(attrs)
          case level {
            1 -> html.h1(attrs, inlines)
            2 -> html.h2(attrs, inlines)
            4 -> html.h4(attrs, inlines)
            5 -> html.h5(attrs, inlines)
            6 -> html.h6(attrs, inlines)
            _ -> html.h1(attrs, inlines)
          }
        }
        pd.Para(content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          html.p([], inlines)
        }
        pd.Plain(content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          html.span([], inlines)
        }
        pd.Div(attrs, content) -> {
          let blocks =
            list.map(content, block_to_lustre_with(
              _,
              block_renderer,
              inline_renderer,
              meta,
            ))
          let attributes = attributes_to_lustre(attrs)
          html.div(attributes, blocks)
        }
        pd.BulletList(items) -> {
          let list_items =
            list_items_to_lustre(items, block_renderer, inline_renderer, meta)
          html.ul([], list_items)
        }
        pd.CodeBlock(attrs, text) -> {
          let attributes = attributes_to_lustre(attrs)
          html.pre(attributes, [html.code([], [html.text(text)])])
        }
        pd.OrderedList(attrs, items) -> {
          let list_items =
            list_items_to_lustre(items, block_renderer, inline_renderer, meta)
          let attributes = list_attributes_to_lustre(attrs)
          html.ol(attributes, list_items)
        }
      }
  }
}

fn inline_to_lustre_with(
  inline: pd.Inline,
  inline_renderer: InlineRenderer(msg),
  meta: pd.Meta,
) -> Element(msg) {
  case inline_renderer(inline, meta) {
    Some(el) -> el
    None ->
      case inline {
        pd.Str(content) -> html.text(content)
        pd.Space -> html.text(" ")
        pd.Emph(content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          html.em([], inlines)
        }
        pd.Strong(content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          html.strong([], inlines)
        }
        pd.Strikeout(content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          html.s([], inlines)
        }
        pd.Code(attrs, text) -> {
          let attributes = attributes_to_lustre(attrs)
          html.code(attributes, [html.text(text)])
        }
        pd.Span(attrs, content) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          let attributes = attributes_to_lustre(attrs)
          html.span(attributes, inlines)
        }
        pd.Link(attrs, content, target) -> {
          let inlines =
            list.map(content, inline_to_lustre_with(_, inline_renderer, meta))
          let attributes = attributes_to_lustre(attrs)
          let href = attribute.href(target.url)
          let title = case target.title {
            "" -> []
            title -> [attribute.title(title)]
          }
          html.a(list.flatten([attributes, [href], title]), inlines)
        }
      }
  }
}

fn attributes_to_lustre(
  attrs: pd.Attributes,
) -> List(attribute.Attribute(msg)) {
  let id = case attrs.id {
    "" -> []
    id -> [attribute.id(id)]
  }
  let classes = case attrs.classes {
    [] -> []
    classes -> [attribute.class(string.join(classes, with: " "))]
  }
  let keyvalues =
    list.map(attrs.keyvalues, fn(kv) { attribute.attribute(kv.0, kv.1) })
  list.flatten([id, classes, keyvalues])
}

fn list_attributes_to_lustre(
  attrs: pd.ListAttributes,
) -> List(attribute.Attribute(msg)) {
  let start = attribute.attribute("start", int.to_string(attrs.start))
  let type_ = case attrs.style {
    pd.Decimal -> attribute.attribute("type", "1")
    pd.LowerAlpha -> attribute.attribute("type", "a")
    pd.UpperAlpha -> attribute.attribute("type", "A")
    pd.LowerRoman -> attribute.attribute("type", "i")
    pd.UpperRoman -> attribute.attribute("type", "I")
  }
  [start, type_]
}

fn list_items_to_lustre(
  items: List(List(pd.Block)),
  block_renderer: BlockRenderer(msg),
  inline_renderer: InlineRenderer(msg),
  meta: pd.Meta,
) -> List(Element(msg)) {
  list.map(items, fn(item) {
    let blocks =
      list.map(item, block_to_lustre_with(
        _,
        block_renderer,
        inline_renderer,
        meta,
      ))
    html.li([], blocks)
  })
}
