import gleam/list
import gleam/string
import pandi as doc

pub fn gleam_playground_link(gleam_code: String) -> doc.Block {
  let url = "https://playground.gleam.run/#" <> make_v1_hash(gleam_code)
  doc.Para(content: [
    doc.Link(
      attributes: doc.Attributes(id: "", classes: [], keyvalues: []),
      target: doc.Target(url: url, title: "Gleam playground"),
      content: text("Open code in Gleam playground 🔗"),
    ),
  ])
}

pub fn text(text: String) -> List(doc.Inline) {
  string.split(text, on: " ")
  |> list.map(doc.Str)
  |> list.intersperse(doc.Space)
}

@external(javascript, "./lz_ffi.mjs", "makeV1Hash")
fn make_v1_hash(code: String) -> String
