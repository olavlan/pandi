import birdie
import gleam/option.{None, Some}
import lustre/attribute.{href}
import lustre/element
import lustre/element/html
import pandi as pd
import pandoc_lustre_converter.{
  type BlockFilter, type InlineFilter, convert_with_filter,
}

fn snapshot(
  blocks: List(pd.Block),
  block_filter: BlockFilter(msg),
  inline_filter: InlineFilter(msg),
  title: String,
) {
  pd.Document(blocks, [])
  |> convert_with_filter(block_filter, inline_filter)
  |> element.to_readable_string
  |> birdie.snap(title: "[convert_with_filter] " <> title)
}

pub fn increase_header_level_test() {
  let blocks = [
    pd.Header(1, pd.Attributes("", [], []), [
      pd.Str("Header"),
      pd.Space,
      pd.Str("with"),
      pd.Space,
      pd.Str("#tag"),
    ]),
    pd.Para([
      pd.Str("Paragraph"),
      pd.Space,
      pd.Str("with"),
      pd.Space,
      pd.Str("#another-tag"),
    ]),
  ]
  let block_filter: BlockFilter(msg) = fn(_, _) { None }
  let inline_filter: InlineFilter(msg) = fn(inline, _meta) {
    case inline {
      pd.Str("#" <> tag) ->
        Some(html.a([href("/tags/" <> tag)], [html.text(tag)]))
      _ -> None
    }
  }
  snapshot(
    blocks,
    block_filter,
    inline_filter,
    "put all #tags in link element pointing to /tags/[tagname]",
  )
}
