import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element as lustre
import lustre/element/html
import pandi/doc

///A block converter is a function that takes a block
///and returns and action, where an action is constructed using 
///either `default` (converting the element in the default way)
///or `custom` (giving a custom lustre element instead).
///
///Example:
///
///
pub type BlockConverter(msg) =
  fn(doc.Block, doc.Meta) -> Action(msg)

///A block converter is a function that takes an inline
///and produces and action, where an action is constructed using 
///either `default` (converting the element in the default way)
///or `custom` (giving a custom lustre element instead).
///
///Example:
///
///
pub type InlineConverter(msg) =
  fn(doc.Inline, doc.Meta) -> Action(msg)

///The type that converters should return.
///Use the provided constructors `default` and `custom`.
pub opaque type Action(msg) {
  WithDefaults(
    document_elements: List(DocumentElement),
    callback: fn(lustre.Element(msg)) -> Action(msg),
  )
  Default
  Custom(element: lustre.Element(msg))
}

///Action to convert a document element the default way.
pub const default: Action(msg) = Default

///Action to convert a document element to a custom Lustre element.
pub fn custom(element: lustre.Element(msg)) -> Action(msg) {
  Custom(element)
}

///Action to convert some (block) children of a document element in the default way,
///and use the result to contruct a new action.
pub fn default_blocks(
  blocks: List(doc.Block),
  callback: fn(lustre.Element(msg)) -> Action(msg),
) -> Action(msg) {
  WithDefaults(list.map(blocks, BlockElement), callback)
}

///Action to convert some (inline) children of a document element in the default way,
///and use the result to contruct a new action.
pub fn default_inlines(
  inlines: List(doc.Inline),
  callback: fn(lustre.Element(msg)) -> Action(msg),
) -> Action(msg) {
  WithDefaults(list.map(inlines, InlineElement), callback)
}

///Converts a document with the given block and inline converters.
pub fn convert_document(
  document: doc.Document,
  block_converter: BlockConverter(msg),
  inline_converter: InlineConverter(msg),
) -> lustre.Element(msg) {
  //Since we don't care about blocks and inlines
  //when converting to Lustre elements,
  //we simplify by constructing a single generic converter..
  let converter = combine_converters(block_converter, inline_converter)
  //..that we use to convert the document block:
  convert_blocks(document.blocks, converter, document.meta)
}

//A generic converter...
type Converter(msg) =
  fn(DocumentElement, doc.Meta) -> Action(msg)

//..works on any document element:
type DocumentElement {
  BlockElement(block: doc.Block)
  InlineElement(inline: doc.Inline)
}

//The generic converter is contructed by dispatching
//to either the block or inline converter:
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

// When converting a list of blocks, we start by mapping each block to
// a generic document element...
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

// We then convert a generic list of document elements
// by converting each element separately and putting the results
// into a Lustre fragment:
fn convert_document_elements(
  document_elements: List(DocumentElement),
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(document_elements, convert_document_element(_, converter, meta))
  |> lustre.fragment
}

// When converting a document element we first need to apply
// the user-provided converter to it to see what action to use...
fn convert_document_element(
  document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  converter(document_element, meta)
  |> convert_document_element_with_action(document_element, converter, meta)
}

// ..and then convert it using that action in the next function.

/// The flow of this function is best explained with an example.
/// The following block converter...
/// ```gleam
/// let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
///   case block {
///     doc.Para(content) -> {
///       use text <- pl.default_inlines(content)
///       html.div([], [text])
///       |> pl.custom
///     }
///     _ -> pl.default
///   }
/// }
/// ```
/// ...will resolve to:
/// ```gleam
/// let block_converter: BlockConverter(msg) = fn(block, _meta) {
///   case block {
///     doc.Para(content) -> {
///       WithDefaults(list.map(content, InlineElement), fn(text) {
///         Custom(html.div([], [text]))
///       })
///     }
///     _ -> Default
///   }
/// }
/// ```
/// When we convert a paragraph, the first action will be of type `WithDefaults`.
/// We "unwrap" that action by converting the inline elements and using the callback on the result.
/// The unwrapped action is then processed recursively
/// and this time we will match on the `Custom` branch.
fn convert_document_element_with_action(
  action: Action(msg),
  document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case action {
    //Unwrap`WithDefaults` until we get to a `Custom` action:
    WithDefaults(document_elements, callback) ->
      document_elements
      |> list.map(convert_document_element(_, converter, meta))
      |> lustre.fragment
      |> callback
      //In practice, the callback will eventually produce a `Custom` action,
      //and the recursion will stop (see example above):
      |> convert_document_element_with_action(document_element, converter, meta)
    //Convertan element using the default rules (children still subject to custom rules):
    Default ->
      case document_element {
        BlockElement(block) -> convert_block(block, converter, meta)
        InlineElement(inline) -> convert_inline(inline, converter, meta)
      }
    Custom(element) -> element
  }
}

//Convert a block with the default rules (children still subject to custom rules):
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

//Convert an inline with the default rules (children still subject to custom rules):
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

/// Convert document attributes to a list of Lustre attributes.
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

/// Convert document list attributes to a list of Lustre attributes.
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
