import birdie
import lustre/attribute.{href}
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as pl

fn snapshot(
  blocks: List(doc.Block),
  block_filter: pl.BlockConverter(msg),
  inline_filter: pl.InlineConverter(msg),
  title: String,
) {
  doc.Document(blocks, [])
  |> pl.convert_document(block_filter, inline_filter)
  |> element.to_readable_string
  |> birdie.snap(title: "[convert_document] " <> title)
}

const empty_attributes = doc.Attributes("", [], [])

pub fn convert_tags_to_links_test() {
  let blocks = [
    doc.Header(1, empty_attributes, doc.text("Header with #tag")),
    doc.Para(doc.text("Paragraph with #another-tag")),
  ]
  let block_converter: pl.BlockConverter(msg) = fn(_, _) { pl.default }
  let inline_converter: pl.InlineConverter(msg) = fn(inline, _meta) {
    case inline {
      doc.Str("#" <> tag) ->
        html.a([href("/tags/" <> tag)], [html.text(tag)]) |> pl.custom
      _ -> pl.default
    }
  }
  snapshot(
    blocks,
    block_converter,
    inline_converter,
    "convert all #tags to links pointing to /tags/[tagname]",
  )
}

pub fn convert_div_with_header_to_details_test() {
  let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
        use details <- pl.default_blocks(rest)
        use summary <- pl.default_inlines(inlines)
        html.details([], [
          html.summary([], [summary]),
          details,
        ])
        |> pl.custom
      }
      _ -> pl.default
    }
  }

  let blocks = [
    doc.Div(attributes: empty_attributes, content: [
      doc.Header(
        1,
        empty_attributes,
        content: doc.text("This should be the summary of the details element."),
      ),
      doc.Plain(doc.text("This should be the details of the details element.")),
    ]),
    doc.Para(doc.text("A normal top-level paragraph.")),
    doc.Div(attributes: empty_attributes, content: [
      doc.Plain(doc.text(
        "This div does not start with a header and should therefore not be converted to a details element.",
      )),
    ]),
  ]
  snapshot(
    blocks,
    block_converter,
    fn(_, _) { pl.default },
    "convert all div's starting with a header to details element",
  )
}

pub fn convert_paragraph_to_div_test() {
  let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Para(content) -> {
        use text <- pl.default_inlines(content)
        html.div([], [text])
        |> pl.custom
      }
      _ -> pl.default
    }
  }

  let blocks = [
    doc.Para([
      doc.Emph(doc.text("This text should be")),
      doc.Space,
      doc.Strong(doc.text("inside a div")),
    ]),
    doc.Plain(doc.text("This text should not be in a div.")),
  ]
  snapshot(
    blocks,
    block_converter,
    fn(_, _) { pl.default },
    "convert every paragraph to div",
  )
}
