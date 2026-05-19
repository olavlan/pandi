import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      // remove "comment" lines:
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove
      // append a gleam playground link to each code block:
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        doc.keep |> doc.append(element.gleam_playground_link(code))
      // keep all other inlines (children are still subject to filter):
      _ -> doc.keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      // replace all occurrences of `hex:[package_name]` with a link to the Hex docs:
      doc.Code(_, "hex:" <> package_name) ->
        doc.remove |> doc.append(element.hex_link(package_name))
      // keep all other inlines (children are still subject to filter):
      _ -> doc.keep
    }
  }

  pandoc.parse(from_file: "example.md", from_format: "markdown")
  |> doc.filter_blocks(block_filter)
  |> doc.filter_inlines(inline_filter)
  |> pandoc.render(to_file: "example.html", to_format: "html")
}
