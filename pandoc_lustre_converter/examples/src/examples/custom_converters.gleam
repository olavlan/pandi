import lustre/attribute as attr
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as pl

pub fn main() {
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

  let inline_converter: pl.InlineConverter(msg) = fn(inline, _meta) {
    case inline {
      doc.Str("#" <> tag) ->
        html.a([attr.href("/tags/" <> tag)], [html.text(tag)]) |> pl.custom
      _ -> pl.default
    }
  }

  let empty_attributes = doc.Attributes("", [], [])
  let sample =
    doc.Document(
      blocks: [
        doc.Para(doc.text("A #tag is in this paragraph.")),
        doc.Div(attributes: empty_attributes, content: [
          doc.Header(1, empty_attributes, doc.text("This is the summary")),
          doc.Plain(doc.text("There is #another-tag in the details.")),
        ]),
      ],
      meta: [],
    )

  sample
  |> pl.convert_document(block_converter, inline_converter)
  |> element.to_readable_string
  // <p>
  //   A
  //   <a href="/tags/tag">
  //     tag
  //   </a>
  //    is in this paragraph.
  // </p>
  // <details>
  //   <summary>
  //     This is the summary
  //   </summary>
  //   There is
  //   <a href="/tags/another-tag">
  //     another-tag
  //   </a>
  //    in the details.
  // </details>
}
