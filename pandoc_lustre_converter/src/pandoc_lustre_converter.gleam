//// Module for converting a Pandoc document to a Lustre element, with support for custom conversion rules.
////
//// Complete example:
////
////```gleam
//// import lustre/attribute
//// import lustre/element
//// import lustre/element/html
//// import pandi/doc
//// import pandoc_lustre_converter as pl
//// 
//// pub fn main() {
////   let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
////     case block {
////       doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
////         use details <- pl.default_blocks(rest)
////         use summary <- pl.default_inlines(inlines)
////         html.details([], [
////           html.summary([], [summary]),
////           details,
////         ])
////         |> pl.custom
////       }
////       _ -> pl.default
////     }
////   }
//// 
////   let inline_converter: pl.InlineConverter(msg) = fn(inline, _meta) {
////     case inline {
////       doc.Str("#" <> tag) ->
////         html.a([attribute.href("/tags/" <> tag)], [html.text(tag)]) |> pl.custom
////       _ -> pl.default
////     }
////   }
//// 
////   let empty_attributes = doc.Attributes("", [], [])
////   let sample =
////     doc.Document(
////       blocks: [
////         doc.Para(doc.text("A #tag is in this paragraph.")),
////         doc.Div(attributes: empty_attributes, content: [
////           doc.Header(1, empty_attributes, doc.text("This is the summary")),
////           doc.Plain(doc.text("There is #another-tag in the details.")),
////         ]),
////       ],
////       meta: [],
////     )
//// 
////   sample
////   |> pl.convert_document(block_converter, inline_converter)
////   |> element.to_readable_string
////   // <p>
////   //   A
////   //   <a href="/tags/tag">
////   //     tag
////   //   </a>
////   //    is in this paragraph.
////   // </p>
////   // <details>
////   //   <summary>
////   //     This is the summary
////   //   </summary>
////   //   There is
////   //   <a href="/tags/another-tag">
////   //     another-tag
////   //   </a>
////   //    in the details.
////   // </details>
//// }
//// ```

import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element as lustre
import lustre/element/html
import pandi/doc

///A block converter is a function that takes a block
///and returns and action, where an action is constructed using 
///either `default` (to convert to the default Lustre element)
///or `custom` (to convert to a custom Lustre element).
///
///Example:
///```gleam
/// import lustre/element
/// import pandi/doc
///
/// // ...
///
/// let block_converter: BlockConverter(msg) = fn(block, _meta) {
///   case block {
///     doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
///       use details <- default_blocks(rest)
///       use summary <- default_inlines(inlines)
///       html.details([], [
///         html.summary([], [summary]),
///         details,
///       ])
///       |> custom
///     }
///     _ -> default
///   }
/// }
/// ```
pub type BlockConverter(msg) =
  fn(doc.Block, doc.Meta) -> Action(msg)

///An inline converter is a function that takes an inline
///and produces and action, where an action is constructed using 
///either `default` (to convert to the default Lustre element)
///or `custom` (to convert to a custom Lustre element).
///
///Example:
///
///```gleam
/// import lustre/attribute
/// import lustre/element
/// import pandi/doc
///
/// // ...
///
/// let inline_converter: InlineConverter(msg) = fn(inline, _meta) {
///   case inline {
///     doc.Str("#" <> tag) ->
///       html.a([attribute.href("/tags/" <> tag)], [html.text(tag)]) |> custom
///     _ -> default
///   }
/// }
///```
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

///Action to convert a document element to the default Lustre element.
pub const default: Action(msg) = Default

///Action to convert a document element to a custom Lustre element.
pub fn custom(element: lustre.Element(msg)) -> Action(msg) {
  Custom(element)
}

///Use this when you need a custom conversion rule for a document element,
///but you want some children of the element to be
///converted to the default Lustre element:
///```gleam
/// import lustre/element
/// import pandi/doc
///
/// // ...
///
/// let block_converter: BlockConverter(msg) = fn(block, _meta) {
///   case block {
///     doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
///       use details <- default_blocks(rest)
///       use summary <- default_inlines(inlines)
///       // `details` and `summary` are Lustre elements that can be used as building blocks:
///       html.details([], [
///         html.summary([], [summary]),
///         details,
///       ])
///       |> custom
///     }
///     _ -> default
///   }
/// }
/// ```
pub fn default_blocks(
  blocks: List(doc.Block),
  callback: fn(lustre.Element(msg)) -> Action(msg),
) -> Action(msg) {
  WithDefaults(list.map(blocks, BlockElement), callback)
}

///Use this when you need a custom conversion rule for a document element,
///but you want some children of the element to be
///converted to the default Lustre element:
///```gleam
/// import lustre/element
/// import pandi/doc
///
/// // ...
///
/// let block_converter: BlockConverter(msg) = fn(block, _meta) {
///   case block {
///     doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
///       use details <- default_blocks(rest)
///       use summary <- default_inlines(inlines)
///       // `details` and `summary` are Lustre elements that can be used as building blocks:
///       html.details([], [
///         html.summary([], [summary]),
///         details,
///       ])
///       |> custom
///     }
///     _ -> default
///   }
/// }
/// ```
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
/// When we convert a paragraph with the above rule, the first action will be of type `WithDefaults`.
/// We "unwrap" that action by converting the inline content and using the callback on the result.
/// The unwrapped action is then passed to the function again, 
/// and this time it will match on the `Custom` branch:
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
    Default ->
      case document_element {
        BlockElement(block) -> convert_block(block, converter, meta)
        InlineElement(inline) -> convert_inline(inline, converter, meta)
      }
    Custom(element) -> element
  }
}

//Convert a block with the default rules (but with children still subject to custom rules):
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
    doc.HorizontalRule -> html.hr([])
  }
}

//Convert an inline with the default rules (but with children still subject to custom rules):
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
    doc.Math(math_type, text) -> {
      let delimited = case math_type {
        doc.InlineMath -> "\\(" <> text <> "\\)"
        doc.DisplayMath -> "\\[" <> text <> "\\]"
      }
      html.text(delimited)
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
