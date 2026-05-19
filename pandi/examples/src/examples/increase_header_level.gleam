import examples/pandoc
import pandi as doc

pub fn main() {
  let increase_header_level: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Header(level, attrs, content) ->
        doc.remove |> doc.append(doc.Header(level + 1, attrs, content))
      _ -> doc.keep
    }
  }

  let html =
    "# Hello world"
    |> pandoc.parse("markdown")
    |> doc.filter_blocks(increase_header_level)
    |> pandoc.render("html")

  assert html == "<h2 id=\"hello-world\">Hello world</h2>\n"
}
