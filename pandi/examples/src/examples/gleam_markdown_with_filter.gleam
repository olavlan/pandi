import examples/gleam_markdown/element
import examples/pandoc
import pandi/doc
import pandi/filter

pub fn main() {
  let add_playground_link_to_codeblocks: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        [element.gleam_playground_link(code)] |> filter.append
      _ -> filter.keep
    }
  }

  let create_hex_docs_links: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("docs:" <> package_name) ->
        [element.hex_link(package_name)] |> filter.replace
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(from_file: "example-2.md", from_format: "markdown")
  |> filter.apply_block_filter(add_playground_link_to_codeblocks)
  |> filter.apply_inline_filter(create_hex_docs_links)
  |> pandoc.document_to_file(to_file: "example-2.html", to_format: "html")
}
