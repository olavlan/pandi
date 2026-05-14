import birdie
import lustre/element.{to_readable_string}
import pandi/lustre.{inline_to_lustre}
import pandi/pandoc as pd

fn snapshot(inline: pd.Inline, title: String) {
  inline_to_lustre(inline)
  |> to_readable_string
  |> birdie.snap(title: "[render_inline] " <> title)
}

pub fn str_test() {
  pd.Str("Hello")
  |> snapshot("simple string")
}

pub fn space_test() {
  pd.Space
  |> snapshot("space")
}

pub fn line_break_test() {
  pd.LineBreak
  |> snapshot("line break")
}

pub fn soft_break_test() {
  pd.SoftBreak
  |> snapshot("soft break")
}

pub fn emph_test() {
  pd.Emph([pd.Str("Emphasized")])
  |> snapshot("emphasis")
}

pub fn strong_test() {
  pd.Strong([pd.Str("Bold")])
  |> snapshot("strong")
}

pub fn strikeout_test() {
  pd.Strikeout([pd.Str("Deleted")])
  |> snapshot("strikeout")
}

pub fn code_test() {
  pd.Code(pd.Attributes("", [], []), "let x = 1")
  |> snapshot("inline code without attributes")
}

pub fn code_with_attributes_test() {
  let attrs =
    pd.Attributes("code-1", ["language-gleam"], [#("data-executable", "true")])
  pd.Code(attrs, "fn hello() { \"Hello\" }")
  |> snapshot("inline code with id, class, and keyvalue attributes")
}

pub fn span_test() {
  pd.Span(pd.Attributes("", [], []), [pd.Str("Span content")])
  |> snapshot("span without attributes")
}

pub fn span_with_attributes_test() {
  let attrs = pd.Attributes("my-span", ["highlight"], [#("data-role", "note")])
  pd.Span(attrs, [pd.Str("Styled span")])
  |> snapshot("span with id, classes, and keyvalue attributes")
}

pub fn link_test() {
  let target = pd.Target("https://example.com", "")
  pd.Link(pd.Attributes("", [], []), [pd.Str("Click here")], target)
  |> snapshot("link without title")
}

pub fn link_with_title_test() {
  let target = pd.Target("https://example.com", "Example Site")
  pd.Link(pd.Attributes("", [], []), [pd.Str("Click here")], target)
  |> snapshot("link with title")
}

pub fn link_with_attributes_test() {
  let attrs = pd.Attributes("link-1", ["external"], [#("data-track", "true")])
  let target = pd.Target("https://example.com", "Example")
  pd.Link(attrs, [pd.Str("Attributed link")], target)
  |> snapshot("link with id, classes, and keyvalue attributes")
}
