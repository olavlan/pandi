import birdie
import lustre/attribute.{href}
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as converter

fn snapshot(
  blocks: List(doc.Block),
  block_filter: converter.BlockConverter(msg),
  inline_filter: converter.InlineConverter(msg),
  title: String,
) {
  doc.Document(blocks, [])
  |> converter.convert_document_with(block_filter, inline_filter)
  |> element.to_readable_string
  |> birdie.snap(title: "[convert_document_with] " <> title)
}

pub fn increase_header_level_test() {
  let blocks = [
    doc.Header(1, doc.Attributes("", [], []), [
      doc.Str("Header"),
      doc.Space,
      doc.Str("with"),
      doc.Space,
      doc.Str("#tag"),
    ]),
    doc.Para([
      doc.Str("Paragraph"),
      doc.Space,
      doc.Str("with"),
      doc.Space,
      doc.Str("#another-tag"),
    ]),
  ]
  let block_filter: converter.BlockConverter(msg) = fn(_, _) {
    converter.Default
  }
  let inline_filter: converter.InlineConverter(msg) = fn(inline, _meta) {
    case inline {
      doc.Str("#" <> tag) ->
        html.a([href("/tags/" <> tag)], [html.text(tag)]) |> converter.Custom
      _ -> converter.Default
    }
  }
  snapshot(
    blocks,
    block_filter,
    inline_filter,
    "put all #tags in link element pointing to /tags/[tagname]",
  )
}
