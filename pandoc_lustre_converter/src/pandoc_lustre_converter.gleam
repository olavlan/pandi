import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element as lustre
import lustre/element/html
import pandi/doc

pub opaque type Element(msg) {
  Default
  Custom(element: lustre.Element(msg))
}

pub type BlockConverter(msg) =
  fn(doc.Block, doc.Meta) -> Element(msg)

pub type InlineConverter(msg) =
  fn(doc.Inline, doc.Meta) -> Element(msg)

pub fn convert_document(document: doc.Document) -> lustre.Element(msg) {
  convert_document_with(document, fn(_, _) { Default }, fn(_, _) { Default })
}

pub fn convert_document_with(
  document: doc.Document,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
) -> lustre.Element(msg) {
  convert_blocks_with(
    document.blocks,
    block_converter,
    inline_converter,
    document.meta,
  )
}

pub fn convert_blocks(blocks: List(doc.Block)) -> lustre.Element(msg) {
  convert_blocks_with(blocks, fn(_, _) { Default }, fn(_, _) { Default }, [])
}

pub fn convert_blocks_with(
  blocks: List(doc.Block),
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  let elements =
    list.map(blocks, convert_block_with(
      _,
      block_converter,
      inline_converter,
      meta,
    ))
  lustre.fragment(elements)
}

pub fn convert_inlines(inlines: List(doc.Inline)) -> lustre.Element(msg) {
  convert_inlines_with(inlines, fn(_, _) { Default }, [])
}

pub fn convert_inlines_with(
  inlines: List(doc.Inline),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  let elements =
    list.map(inlines, convert_inline_with(_, inline_converter, meta))
  lustre.fragment(elements)
}

fn convert_block_with(
  block: doc.Block,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case block_converter(block, meta) {
    Custom(element) -> element
    Default ->
      case block {
        doc.Header(level, attrs, content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_converter, meta))
          let attrs = convert_attributes(attrs)
          case level {
            1 -> html.h1(attrs, inlines)
            2 -> html.h2(attrs, inlines)
            3 -> html.h3(attrs, inlines)
            4 -> html.h4(attrs, inlines)
            5 -> html.h5(attrs, inlines)
            6 -> html.h6(attrs, inlines)
            _ -> html.h1(attrs, inlines)
          }
        }
        doc.Para(content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_converter, meta))
          html.p([], inlines)
        }
        doc.Plain(content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_converter, meta))
          lustre.fragment(inlines)
        }
        doc.Div(attrs, content) -> {
          let blocks =
            list.map(content, convert_block_with(
              _,
              block_converter,
              inline_converter,
              meta,
            ))
          let attributes = convert_attributes(attrs)
          html.div(attributes, blocks)
        }
        doc.BulletList(items) -> {
          let list_items =
            convert_list_items(items, block_converter, inline_converter, meta)
          html.ul([], list_items)
        }
        doc.CodeBlock(attrs, text) -> {
          let attributes = convert_attributes(attrs)
          html.pre(attributes, [html.code([], [html.text(text)])])
        }
        doc.OrderedList(attrs, items) -> {
          let list_items =
            convert_list_items(items, block_converter, inline_converter, meta)
          let attributes = convert_list_attributes(attrs)
          html.ol(attributes, list_items)
        }
        doc.BlockQuote(content) -> {
          let blocks =
            list.map(content, convert_block_with(
              _,
              block_converter,
              inline_converter,
              meta,
            ))
          html.blockquote([], blocks)
        }
      }
  }
}

fn convert_inline_with(
  inline: doc.Inline,
  inline_renderer: InlineConverter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case inline_renderer(inline, meta) {
    Custom(element) -> element
    Default ->
      case inline {
        doc.Str(content) -> html.text(content)
        doc.Space -> html.text(" ")
        doc.LineBreak -> html.br([])
        doc.SoftBreak -> html.text(" ")
        doc.Emph(content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_renderer, meta))
          html.em([], inlines)
        }
        doc.Strong(content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_renderer, meta))
          html.strong([], inlines)
        }
        doc.Strikeout(content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_renderer, meta))
          html.del([], inlines)
        }
        doc.Code(attrs, text) -> {
          let attributes = convert_attributes(attrs)
          html.code(attributes, [html.text(text)])
        }
        doc.Span(attrs, content) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_renderer, meta))
          let attributes = convert_attributes(attrs)
          html.span(attributes, inlines)
        }
        doc.Link(attrs, content, target) -> {
          let inlines =
            list.map(content, convert_inline_with(_, inline_renderer, meta))
          let attributes = convert_attributes(attrs)
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

fn convert_attributes(attrs: doc.Attributes) -> List(attribute.Attribute(msg)) {
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

fn convert_list_attributes(
  attrs: doc.ListAttributes,
) -> List(attribute.Attribute(msg)) {
  let start = attribute.attribute("start", int.to_string(attrs.start))
  let type_ = case attrs.style {
    doc.Decimal -> attribute.attribute("type", "1")
    doc.LowerAlpha -> attribute.attribute("type", "a")
    doc.UpperAlpha -> attribute.attribute("type", "A")
    doc.LowerRoman -> attribute.attribute("type", "i")
    doc.UpperRoman -> attribute.attribute("type", "I")
  }
  [start, type_]
}

fn convert_list_items(
  items: List(List(doc.Block)),
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
  meta: doc.Meta,
) -> List(lustre.Element(msg)) {
  list.map(items, fn(item) {
    let blocks =
      list.map(item, convert_block_with(
        _,
        block_converter,
        inline_converter,
        meta,
      ))
    html.li([], blocks)
  })
}
