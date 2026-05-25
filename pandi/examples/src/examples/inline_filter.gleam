import gleam/io
import pandi/doc
import pandi/filter

pub fn main() {
  let attributes = doc.Attributes(id: "", classes: ["gleam"], keyvalues: [])

  let wrap_gleam_in_span: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("Gleam") -> [doc.Span(attributes, [inline])] |> filter.replace
      _ -> filter.keep
    }
  }

  doc.Document([doc.Para(doc.text("Gleam is cool!"))], [])
  |> filter.apply_inline_filter(wrap_gleam_in_span)
  |> doc.to_string
  |> io.println
  // [
  //   Para
  //     [
  //       Span ( "" , [ "gleam" ] , [  ] ) [ Str "Gleam" ] ,
  //       Space ,
  //       Str "is" ,
  //       Space ,
  //       Str "cool!" ,
  //     ] ,
  // ]
}
