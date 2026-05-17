import birdie
import pandi as pd

fn snapshot(document: pd.Document, title: String) {
  document
  |> pd.to_string
  |> birdie.snap(title: "[to_string] " <> title)
}

fn snapshot_with_block(block: pd.Block, title: String) {
  pd.Document([block], [])
  |> snapshot(title)
}

fn snapshot_with_inline(inline: pd.Inline, title: String) {
  pd.Document([pd.Plain([inline])], [])
  |> snapshot(title)
}

pub fn paragraph_test() {
  pd.Para([pd.Str("Paragraph")])
  |> snapshot_with_block("paragraph with one string element")
}

pub fn header_test() {
  pd.Header(1, pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Str("Header text"),
  ])
  |> snapshot_with_block("level 1 header")
}

pub fn plain_test() {
  pd.Plain([pd.Str("Plain text")])
  |> snapshot_with_block("plain block")
}

pub fn code_block_test() {
  pd.CodeBlock(
    pd.Attributes("my-id", ["class1"], [#("key", "value")]),
    "let x = 1",
  )
  |> snapshot_with_block("code block with attributes")
}

pub fn div_test() {
  pd.Div(pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Para([pd.Str("Inside div")]),
  ])
  |> snapshot_with_block("div with paragraph")
}

pub fn bullet_list_test() {
  pd.BulletList([
    [pd.Para([pd.Str("Item 1")])],
    [pd.Para([pd.Str("Item 2")])],
  ])
  |> snapshot_with_block("bullet list with two items")
}

pub fn ordered_list_test() {
  pd.OrderedList(pd.ListAttributes(1, pd.Decimal, pd.Period), [
    [pd.Para([pd.Str("First")])],
    [pd.Para([pd.Str("Second")])],
  ])
  |> snapshot_with_block("ordered list starting at 1")
}

pub fn block_quote_test() {
  pd.BlockQuote([
    pd.Para([pd.Str("Quoted text")]),
  ])
  |> snapshot_with_block("block quote with paragraph")
}

pub fn string_test() {
  pd.Str("string") |> snapshot_with_inline("string")
}

pub fn space_test() {
  pd.Space |> snapshot_with_inline("space")
}

pub fn line_break_test() {
  pd.LineBreak |> snapshot_with_inline("line break")
}

pub fn soft_break_test() {
  pd.SoftBreak |> snapshot_with_inline("soft break")
}

pub fn emph_test() {
  pd.Emph([pd.Str("emphasized")]) |> snapshot_with_inline("emphasis")
}

pub fn strong_test() {
  pd.Strong([pd.Str("strong")]) |> snapshot_with_inline("strong")
}

pub fn strikeout_test() {
  pd.Strikeout([pd.Str("strikeout")]) |> snapshot_with_inline("strikeout")
}

pub fn inline_code_test() {
  pd.Code(pd.Attributes("", [], []), "code")
  |> snapshot_with_inline("inline code")
}

pub fn span_test() {
  pd.Span(pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Str("span text"),
  ])
  |> snapshot_with_inline("span")
}

pub fn link_test() {
  pd.Link(
    pd.Attributes("", [], []),
    [pd.Str("link text")],
    pd.Target("https://example.com", "title"),
  )
  |> snapshot_with_inline("link")
}
