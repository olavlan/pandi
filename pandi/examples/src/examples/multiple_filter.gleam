import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        doc.keep() |> doc.append(gleam_playground_link(code))
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove()
      _ -> doc.keep()
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("hex:" <> package_name) ->
        doc.remove() |> doc.append(hex_link(package_name))
      _ -> doc.keep()
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

fn gleam_playground_link(code: String) -> doc.Block {
  todo
}
