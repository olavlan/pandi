import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc
import pandoc_filter as filter

pub fn main() {
  let block_filter: filter.BlockFilter = fn(block, _meta) {
    case block {
      // remove "comment" lines:
      doc.Para([doc.Str("//" <> _), ..]) -> filter.remove
      // append a gleam playground link to each code block:
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        filter.keep |> filter.append(element.gleam_playground_link(code))
      // keep all other inlines (children are still subject to filter):
      _ -> filter.keep
    }
  }

  let inline_filter: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      // replace all occurrences of `hex:[package_name]` with a link to the Hex docs:
      doc.Code(_, "hex:" <> package_name) ->
        filter.remove |> filter.append(element.hex_link(package_name))
      // keep all other inlines (children are still subject to filter):
      _ -> filter.keep
    }
  }

  pandoc.parse(from_file: "example.md", from_format: "markdown")
  |> filter.filter_blocks(block_filter)
  |> filter.filter_inlines(inline_filter)
  |> pandoc.render(to_file: "example.html", to_format: "html")
}
