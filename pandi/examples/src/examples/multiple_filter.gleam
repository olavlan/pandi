import examples/lz
import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), raw_code) ->
        doc.keep |> doc.append(gleam_playground_link(raw_code))
      _ -> doc.keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("hex:" <> package_name) ->
        doc.remove |> doc.append(hex_link(package_name))
      _ -> doc.keep
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
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  basic_link(url: url, title: title, text: package_name)
}

fn gleam_playground_link(raw_code: String) -> doc.Block {
  let encoded_raw_code = todo
  let url = "https://playground.gleam.run/" <> encoded_raw_code
  doc.Para(content: [
    basic_link(
      url: url,
      title: "Gleam playground",
      text: "Open code in Gleam playground",
    ),
  ])
}

fn basic_link(
  url url: String,
  title title: String,
  text text: String,
) -> doc.Inline {
  doc.Link(
    attributes: doc.Attributes(id: "", classes: [], keyvalues: []),
    target: doc.Target(url: url, title: title),
    content: [doc.Str(text)],
  )
}
