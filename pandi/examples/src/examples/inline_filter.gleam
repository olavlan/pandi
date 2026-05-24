import pandi/doc
import pandi/filter

pub fn main() {
  let document =
    doc.Document(blocks: [doc.Para(doc.text("gleam is cool!"))], meta: [])

  let capitalize_gleam: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("gleam") -> [doc.Str("Gleam")] |> filter.replace
      _ -> filter.keep
    }
  }

  document
  |> filter.apply_inline_filter(capitalize_gleam)
  |> doc.to_string
  // [ Para [ Str "Gleam" , Space , Str "is" , Space , Str "cool!" ] ]
}
