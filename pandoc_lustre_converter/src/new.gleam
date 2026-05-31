import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element as lustre
import lustre/element/html
import pandi/doc

pub fn main() {
  let block_converter: BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
        use details <- default_blocks(rest)
        use summary <- default_inlines(inlines)
        html.div([], [summary, details]) |> custom
      }
      _ -> default
    }
  }

  let empty_attributes = doc.Attributes("", [], [])
  let document =
    doc.Document(
      blocks: [
        doc.Div(attributes: empty_attributes, content: [
          doc.Header(
            1,
            empty_attributes,
            content: doc.text("This is the summary"),
          ),
        ]),
        doc.Para(doc.text("This is the details.")),
      ],
      meta: [],
    )

  document
  |> convert_document(block_converter, fn(_, _) { Default })
  |> lustre.to_readable_string
}

///A block converter is a function that takes a block
///and returns and action, where an action is constructed using 
///either `default` (converting the element in the default way)
///or `custom` (giving a custom lustre element instead).
pub type BlockConverter(msg) =
  fn(doc.Block, doc.Meta) -> Action(msg)

///A block converter is a function that takes an inline
///and produces and action, where an action is constructed using 
///either `default` (converting the element in the default way)
///or `custom` (giving a custom lustre element instead).
pub type InlineConverter(msg) =
  fn(doc.Inline, doc.Meta) -> Action(msg)

///The type that converters should return.
///Use the provided constructors `default` and `custom`.
pub opaque type Action(msg) {
  //The base cases are to either convert an element
  //in the default way.. 
  Default
  //..or give a custom element:
  Custom(element: lustre.Element(msg))
  //The recursive case is used to create an action 
  //based on first converting some document elements
  //in the default way (e.g. convert the children
  //of a div to insert them in a new element):
  WithDefaults(
    document_elements: List(DocumentElement),
    callback: fn(lustre.Element(msg)) -> Action(msg),
  )
}

//An action to convert a document element in the default way.
//
//Typically used to convert the remaining document elements
//after defining the custom conversion patterns:
pub const default: Action(msg) = Default

//An action to convert a document element to a given Lustre element.
//
//This gives full flexibility to convert certain document elements
//in a specific way:
pub fn custom(element: lustre.Element(msg)) -> Action(msg) {
  Custom(element)
}

pub fn default_blocks(
  blocks: List(doc.Block),
  callback: fn(lustre.Element(msg)) -> Action(msg),
) -> Action(msg) {
  WithDefaults(list.map(blocks, BlockElement), callback)
}

pub fn default_inlines(
  inlines: List(doc.Inline),
  callback: fn(lustre.Element(msg)) -> Action(msg),
) -> Action(msg) {
  WithDefaults(list.map(inlines, InlineElement), callback)
}

pub fn convert_document(
  document: doc.Document,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
) -> lustre.Element(msg) {
  let converter = combine_converters(block_converter, inline_converter)
  convert_blocks(document.blocks, converter, document.meta)
}

// Whether we convert from a block or inline does not matter
// for the Lustre output element, so in the implementation
// we will work with a general document element:
type DocumentElement {
  BlockElement(block: doc.Block)
  InlineElement(inline: doc.Inline)
}

// Thus we will also work with a general converter..
type Converter(msg) =
  fn(DocumentElement, doc.Meta) -> Action(msg)

//..that can be contructed from the user's block and inline converter: 
fn combine_converters(
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
) -> Converter(msg) {
  fn(element, meta) {
    case element {
      BlockElement(block) -> block_converter(block, meta)
      InlineElement(inline) -> inline_converter(inline, meta)
    }
  }
}

// When converting a list of blocks, we simply map each block to
// a general document element first...
fn convert_blocks(
  blocks: List(doc.Block),
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(blocks, BlockElement)
  |> convert_document_elements(converter, meta)
}

//..and similarly when converting a list of inlines:
fn convert_inlines(
  inlines: List(doc.Inline),
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(inlines, InlineElement)
  |> convert_document_elements(converter, meta)
}

// Now we can convert a general list of document elements
// by converting each separately and putting the results
// into a Lustre fragment:
fn convert_document_elements(
  document_elements: List(DocumentElement),
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(document_elements, convert_document_element(_, converter, meta))
  |> lustre.fragment
}

// When converting a document element we need to firt apply
// the user-provided converter to it to see what action we should use...
fn convert_document_element(
  document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  converter(document_element, meta)
  |> convert_document_element_with_action(document_element, converter, meta)
}

// ..and then convert it based on the action.  
fn convert_document_element_with_action(
  action: Action(msg),
  document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case action {
    WithDefaults(document_elements, callback) ->
      document_elements
      |> list.map(convert_document_element(_, converter, meta))
      |> lustre.fragment
      |> callback
      |> convert_document_element_with_action(document_element, converter, meta)

    Custom(element) -> element
    Default ->
      case document_element {
        BlockElement(block) -> convert_block(block, converter, meta)
        InlineElement(inline) -> convert_inline(inline, converter, meta)
      }
  }
}

fn convert_block(
  block: doc.Block,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case block {
    doc.Header(level, attrs, content) -> {
      let child = convert_inlines(content, converter, meta)
      let attrs = convert_attributes(attrs)
      case level {
        1 -> html.h1(attrs, [child])
        2 -> html.h2(attrs, [child])
        3 -> html.h3(attrs, [child])
        4 -> html.h4(attrs, [child])
        5 -> html.h5(attrs, [child])
        6 -> html.h6(attrs, [child])
        _ -> html.h1(attrs, [child])
      }
    }
    doc.Para(content) -> {
      let child = convert_inlines(content, converter, meta)
      html.p([], [child])
    }
    doc.Plain(content) -> {
      convert_inlines(content, converter, meta)
    }
    doc.Div(attrs, content) -> {
      let child = convert_blocks(content, converter, meta)
      let attributes = convert_attributes(attrs)
      html.div(attributes, [child])
    }
    doc.BulletList(items) -> {
      let list_items = convert_list_items(items, converter, meta)
      html.ul([], list_items)
    }
    doc.CodeBlock(attrs, text) -> {
      let attributes = convert_attributes(attrs)
      html.pre(attributes, [html.code([], [html.text(text)])])
    }
    doc.OrderedList(attrs, items) -> {
      let list_items = convert_list_items(items, converter, meta)
      let attributes = convert_list_attributes(attrs)
      html.ol(attributes, list_items)
    }
    doc.BlockQuote(content) -> {
      let child = convert_blocks(content, converter, meta)
      html.blockquote([], [child])
    }
  }
}

fn convert_inline(
  inline: doc.Inline,
  converter: Converter(msg),
  meta: doc.Meta,
) {
  case inline {
    doc.Str(content) -> html.text(content)
    doc.Space -> html.text(" ")
    doc.LineBreak -> html.br([])
    doc.SoftBreak -> html.text(" ")
    doc.Emph(content) -> {
      let child = convert_inlines(content, converter, meta)
      html.em([], [child])
    }
    doc.Strong(content) -> {
      let child = convert_inlines(content, converter, meta)
      html.strong([], [child])
    }
    doc.Strikeout(content) -> {
      let child = convert_inlines(content, converter, meta)
      html.del([], [child])
    }
    doc.Code(attrs, text) -> {
      let attributes = convert_attributes(attrs)
      html.code(attributes, [html.text(text)])
    }
    doc.Span(attrs, content) -> {
      let child = convert_inlines(content, converter, meta)
      let attributes = convert_attributes(attrs)
      html.span(attributes, [child])
    }
    doc.Link(attrs, content, target) -> {
      let child = convert_inlines(content, converter, meta)
      let attributes = convert_attributes(attrs)
      let href = attribute.href(target.url)
      let title = case target.title {
        "" -> []
        title -> [attribute.title(title)]
      }
      html.a(list.flatten([attributes, [href], title]), [child])
    }
  }
}

pub fn convert_attributes(
  attrs: doc.Attributes,
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
  converter: Converter(msg),
  meta: doc.Meta,
) -> List(lustre.Element(msg)) {
  list.map(items, fn(item) {
    let content = convert_blocks(item, converter, meta)
    html.li([], [content])
  })
}
