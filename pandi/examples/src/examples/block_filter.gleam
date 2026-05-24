import pandi/doc
import pandi/filter

pub fn main() {
  let document =
    doc.Document(
      blocks: [
        doc.Header(
          level: 1,
          attributes: doc.Attributes("", [], []),
          content: doc.text("Header"),
        ),
      ],
      meta: [],
    )

  let increase_header_level: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Header(level, attrs, content) ->
        [doc.Header(level + 1, attrs, content)] |> filter.replace
      _ -> filter.keep
    }
  }

  document
  |> filter.apply_block_filter(increase_header_level)
  |> doc.to_string
  // [
  //   Header 2 ( "" , [  ] , [  ] ) [ Str "Header" ] ,
  //   Para [ Str "Paragraph" , Space , Str "after" , Space , Str "header." ] ,
  // ]
}
