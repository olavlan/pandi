import examples/pandoc.{parse}
import gleam/option.{None, Some}
import pandoc_lustre_converter

pub fn main() {
  let increase_header_level: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.Header(level, attrs, content) ->
        Some([pd.Header(level + 1, attrs, content)])
      _ -> None
    }
  }

  let html =
    "# Hello world"
    |> parse("markdown")
    |> pd.filter_blocks(increase_header_level)
    |> render("html")

  assert html == "<h2 id=\"hello-world\">Hello world</h2>\n"
}
