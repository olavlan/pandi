import gleam/io
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as pl

pub fn main() {
  let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(doc.Attributes(_, ["collapse"], [#("summary", summary)]), blocks) ->
        html.div([], pl.convert_blocks(blocks)) |> pl.Custom
      _ -> pl.Default
    }
  }

  let inline_converter: pl.InlineConverter(msg) = fn(inline, _meta) {
    case inline {
      doc.Str("#" <> tag) ->
        html.a([attr.href("/tags/" <> tag)], [html.text(tag)])
        |> pl.Custom
      _ -> pl.Default
    }
  }

  let sample =
    doc.Document(
      blocks: [
        doc.Para(doc.text("A #tag is in this paragraph.")),
        doc.Div(
          attributes: doc.Attributes("", ["collapse"], [
            #("summary", "The summary"),
          ]),
          content: [doc.Para(doc.text("The details."))],
        ),
      ],
      meta: [],
    )

  sample
  |> pl.convert_document_with(block_converter, inline_converter)
  |> element.to_readable_string
  |> io.println
}
