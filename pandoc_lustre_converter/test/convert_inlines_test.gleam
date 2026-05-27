import birdie
import lustre/element.{to_readable_string}
import pandi/doc
import pandoc_lustre_converter.{convert_inlines}

fn snapshot(inline: doc.Inline, title: String) {
  convert_inlines([inline])
  |> to_readable_string
  |> birdie.snap(title: "[convert_inlines] " <> title)
}

pub fn string_test() {
  doc.Str("string") |> snapshot("string")
}

pub fn space_test() {
  doc.Space |> snapshot("space")
}

pub fn line_break_test() {
  doc.LineBreak |> snapshot("line break")
}

pub fn soft_break_test() {
  doc.SoftBreak |> snapshot("soft break")
}

pub fn emph_test() {
  doc.Emph([doc.Str("emphasized")]) |> snapshot("emphasis")
}

pub fn strong_test() {
  doc.Strong([doc.Str("strong")]) |> snapshot("strong")
}

pub fn strikeout_test() {
  doc.Strikeout([doc.Str("strikeout")]) |> snapshot("strikeout")
}

pub fn inline_code_test() {
  doc.Code(doc.Attributes("", [], []), "code")
  |> snapshot("inline code")
}

pub fn span_test() {
  doc.Span(doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Str("span text"),
  ])
  |> snapshot("span")
}

pub fn link_test() {
  doc.Link(
    doc.Attributes("", [], []),
    [doc.Str("link text")],
    doc.Target("https://example.com", "title"),
  )
  |> snapshot("link")
}
