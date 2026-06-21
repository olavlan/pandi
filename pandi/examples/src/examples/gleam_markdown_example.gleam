import examples/gleam_markdown as element
import examples/pandoc
import gleam/list
import pandi/doc

fn process_block(block: doc.Block) -> List(doc.Block) {
  case block {
    doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) -> [
      block,
      element.gleam_playground_link(code),
    ]
    _ -> [block]
  }
}

fn process_top_level_blocks(document: doc.Document) -> doc.Document {
  let new_blocks = list.flat_map(document.blocks, process_block)
  doc.Document(..document, blocks: new_blocks)
}

pub fn main() {
  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> process_top_level_blocks
  |> pandoc.document_to_file(to_file: "example.html", to_format: "html")
}
