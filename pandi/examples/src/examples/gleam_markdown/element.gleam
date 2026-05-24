import pandi/doc

pub fn hex_link(package_name: String) -> doc.Inline {
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  doc.Link(
    attributes: empty_attributes(),
    target: doc.Target(url: url, title: title),
    content: [
      doc.Code(attributes: empty_attributes(), text: package_name),
      doc.Space,
      doc.Str("🔗"),
    ],
  )
}

pub fn gleam_playground_link(gleam_code: String) -> doc.Block {
  let url = "https://playground.gleam.run/#" <> make_v1_hash(gleam_code)
  doc.Para(content: [
    doc.Link(
      attributes: empty_attributes(),
      target: doc.Target(url: url, title: "Gleam playground"),
      content: doc.text("Open code in Gleam playground 🔗"),
    ),
  ])
}

fn empty_attributes() -> doc.Attributes {
  doc.Attributes(id: "", classes: [], keyvalues: [])
}

@external(javascript, "./lz_ffi.mjs", "makeV1Hash")
fn make_v1_hash(code: String) -> String
