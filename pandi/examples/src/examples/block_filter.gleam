import pandi/doc
import pandi/filter

pub fn main() {
  let attributes = doc.Attributes(id: "", classes: ["gleam"], keyvalues: [])

  let wrap_code_blocks_in_div: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(_, _) -> [doc.Div(attributes, [block])] |> filter.replace
      _ -> filter.keep
    }
  }

  doc.Document([doc.CodeBlock(attributes, "pub const pi = 3.14")], [])
  |> filter.apply_block_filter(wrap_code_blocks_in_div)
  |> doc.to_string
  // [
  //   Div
  //     ( "" , [ "gleam" ] , [  ] )
  //     [ CodeBlock ( "" , [ "gleam" ] , [  ] ) "pub const pi = 3.14" ] ,
  // ]
}
