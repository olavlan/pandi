import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        doc.keep |> doc.append(element.gleam_playground_link(code))
      _ -> doc.keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("hex:" <> package_name) ->
        doc.remove |> doc.append(element.hex_link(package_name))
      _ -> doc.keep
    }
  }

  pandoc.parse("./src/examples/gleam_markdown/example.md")
  |> doc.filter_blocks(block_filter)
  |> doc.filter_inlines(inline_filter)
  |> pandoc.render("./src/examples/gleam_markdown/example.html")
}
