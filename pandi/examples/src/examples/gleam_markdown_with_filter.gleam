import examples/gleam_markdown/element
import examples/pandoc
import pandi/doc
import pandi/filter

pub fn main() {
  let block_filter: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        [element.gleam_playground_link(code)] |> filter.append
      _ -> filter.keep
    }
  }

  let inline_filter: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Code(_, "docs:" <> package_name) ->
        [element.hex_link(package_name)] |> filter.replace
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(from_file: "example-2.md", from_format: "markdown")
  |> filter.apply_block_filter(block_filter)
  |> filter.apply_inline_filter(inline_filter)
  |> pandoc.document_to_file(to_file: "example-2.html", to_format: "html")
}
