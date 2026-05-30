import gleam/list
import lustre/element as lustre
import lustre/element/html
import pandi/doc

pub fn main() {
  let converter: Converter(msg) = fn(element, _meta) {
    case element {
      BlockElement(block) -> {
        case block {
          doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
            use details <- default_blocks(rest)
            use summary <- default_inlines(inlines)
            html.div([], [summary, details]) |> custom
          }
          _ -> default
        }
      }
      _ -> default
    }
  }

  converter
}

pub fn default_blocks(
  blocks: List(doc.Block),
  callback: fn(lustre.Element(msg)) -> Element(msg),
) -> Element(msg) {
  WithDefault(list.map(blocks, BlockElement), callback)
}

pub fn default_inlines(
  inlines: List(doc.Inline),
  callback: fn(lustre.Element(msg)) -> Element(msg),
) -> Element(msg) {
  WithDefault(list.map(inlines, InlineElement), callback)
}

pub fn custom(element: lustre.Element(msg)) -> Element(msg) {
  Custom(element)
}

const default: Element(msg) = Default

pub type DocumentElement {
  BlockElement(block: doc.Block)
  InlineElement(inline: doc.Inline)
}

pub opaque type Element(msg) {
  Custom(element: lustre.Element(msg))
  WithDefault(
    document_elements: List(DocumentElement),
    callback: fn(lustre.Element(msg)) -> Element(msg),
  )
  Default
}

pub type Converter(msg) =
  fn(DocumentElement, doc.Meta) -> Element(msg)

pub fn public() {
  convert_document_elements([], fn(_, _) { Default }, [])
}

fn convert_document_elements(
  document_elements: List(DocumentElement),
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  list.map(document_elements, convert_document_element(_, converter, meta))
  |> lustre.fragment
}

fn convert_document_element(
  document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  converter(document_element, meta)
  |> convert_element(document_element, converter, meta)
}

fn convert_element(
  element: Element(msg),
  original_document_element: DocumentElement,
  converter: Converter(msg),
  meta: doc.Meta,
) -> lustre.Element(msg) {
  case element {
    WithDefault(document_elements, callback) ->
      document_elements
      |> list.map(convert_document_element(_, converter, meta))
      |> lustre.fragment
      |> callback
      |> convert_element(original_document_element, converter, meta)

    Custom(element) -> element
    Default ->
      case original_document_element {
        _ -> lustre.none()
      }
  }
}
