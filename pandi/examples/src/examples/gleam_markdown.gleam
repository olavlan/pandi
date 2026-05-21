import examples/gleam_markdown/element
import examples/pandoc
import gleam/list
import pandi as doc

pub fn main() {
  pandoc.parse(from_file: "example.md", from_format: "markdown")
  |> filter_top_level_blocks
  |> pandoc.render(to_file: "example.html", to_format: "html")
}

fn filter_top_level_blocks(document: doc.Document) -> doc.Document {
  let new_blocks = list.flat_map(document.blocks, filter_block)
  doc.Document(..document, blocks: new_blocks)
}

fn filter_block(block: doc.Block) -> List(doc.Block) {
  case block {
    doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) -> [
      block,
      element.gleam_playground_link(code),
    ]
    _ -> [block]
  }
}
