import birdie
import lustre/element.{to_readable_string}
import pandi as pd
import pandoc_lustre_converter.{convert_inlines}

fn snapshot(inline: pd.Inline, title: String) {
  convert_inlines([inline])
  |> to_readable_string
  |> birdie.snap(title: "[convert_inlines] " <> title)
}

pub fn string_test() {
  pd.Str("string") |> snapshot("string")
}

pub fn space_test() {
  pd.Space |> snapshot("space")
}

pub fn line_break_test() {
  pd.LineBreak |> snapshot("line break")
}

pub fn soft_break_test() {
  pd.SoftBreak |> snapshot("soft break")
}

pub fn emph_test() {
  pd.Emph([pd.Str("emphasized")]) |> snapshot("emphasis")
}

pub fn strong_test() {
  pd.Strong([pd.Str("strong")]) |> snapshot("strong")
}

pub fn strikeout_test() {
  pd.Strikeout([pd.Str("strikeout")]) |> snapshot("strikeout")
}

pub fn inline_code_test() {
  pd.Code(pd.Attributes("", [], []), "code")
  |> snapshot("inline code")
}

pub fn span_test() {
  pd.Span(pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Str("span text"),
  ])
  |> snapshot("span")
}

pub fn link_test() {
  pd.Link(
    pd.Attributes("", [], []),
    [pd.Str("link text")],
    pd.Target("https://example.com", "title"),
  )
  |> snapshot("link")
}
