import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc
import pandi/filter

pub fn main() {
  let block_filter: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        filter.keep |> filter.append(element.gleam_playground_link(code))
      _ -> filter.keep
    }
  }

  let inline_filter: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Code(_, "docs:" <> package_name) ->
        filter.remove |> filter.append(element.hex_link(package_name))
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(
    from_file: "example-with-nesting.md",
    from_format: "markdown",
  )
  |> filter.filter_blocks(block_filter)
  |> filter.filter_inlines(inline_filter)
  |> pandoc.document_to_file(
    to_file: "example-with-nesting.html",
    to_format: "html",
  )
}
