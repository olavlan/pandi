import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        gleam_playground_link(code) |> doc.Prepend
      doc.Para([doc.Str("//" <> _), ..]) -> doc.Remove
      _ -> doc.Keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("hex:" <> package_name) -> hex_link(package_name) |> doc.Replace
      _ -> doc.Keep
    }
  }

  let html =
    ""
    |> pandoc.parse("markdown")
    |> doc.filter_blocks(block_filter)
    |> doc.filter_inlines(inline_filter)
    |> pandoc.render("markdown")
    |> echo

  assert html == "<h2 id=\"hello-world\">Hello world</h2>\n"
}

fn hex_link(package_name: String) -> doc.Inline {
  todo
}

fn gleam_playground_link(code: String) -> doc.Inline {
  todo
}
