import birdie
import pandi/doc

fn snapshot(document: doc.Document, title: String) {
  document
  |> doc.to_string
  |> birdie.snap(title: "[to_string] " <> title)
}

fn snapshot_with_block(block: doc.Block, title: String) {
  doc.Document([block], [])
  |> snapshot(title)
}

fn snapshot_with_inline(inline: doc.Inline, title: String) {
  doc.Document([doc.Plain([inline])], [])
  |> snapshot(title)
}

pub fn paragraph_test() {
  doc.Para([doc.Str("Paragraph")])
  |> snapshot_with_block("paragraph with one string element")
}

pub fn header_test() {
  doc.Header(1, doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Str("Header text"),
  ])
  |> snapshot_with_block("level 1 header")
}

pub fn plain_test() {
  doc.Plain([doc.Str("Plain text")])
  |> snapshot_with_block("plain block")
}

pub fn code_block_test() {
  doc.CodeBlock(
    doc.Attributes("my-id", ["class1"], [#("key", "value")]),
    "let x = 1",
  )
  |> snapshot_with_block("code block with attributes")
}

pub fn div_test() {
  doc.Div(doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Para([doc.Str("Inside div")]),
  ])
  |> snapshot_with_block("div with paragraph")
}

pub fn bullet_list_test() {
  doc.BulletList([
    [doc.Para([doc.Str("Item 1")])],
    [doc.Para([doc.Str("Item 2")])],
  ])
  |> snapshot_with_block("bullet list with two items")
}

pub fn ordered_list_test() {
  doc.OrderedList(doc.ListAttributes(1, doc.Decimal, doc.Period), [
    [doc.Para([doc.Str("First")])],
    [doc.Para([doc.Str("Second")])],
  ])
  |> snapshot_with_block("ordered list starting at 1")
}

pub fn block_quote_test() {
  doc.BlockQuote([
    doc.Para([doc.Str("Quoted text")]),
  ])
  |> snapshot_with_block("block quote with paragraph")
}

pub fn horizontal_rule_test() {
  doc.HorizontalRule
  |> snapshot_with_block("horizontal rule")
}

pub fn string_test() {
  doc.Str("string") |> snapshot_with_inline("string")
}

pub fn space_test() {
  doc.Space |> snapshot_with_inline("space")
}

pub fn line_break_test() {
  doc.LineBreak |> snapshot_with_inline("line break")
}

pub fn soft_break_test() {
  doc.SoftBreak |> snapshot_with_inline("soft break")
}

pub fn emph_test() {
  doc.Emph([doc.Str("emphasized")]) |> snapshot_with_inline("emphasis")
}

pub fn strong_test() {
  doc.Strong([doc.Str("strong")]) |> snapshot_with_inline("strong")
}

pub fn strikeout_test() {
  doc.Strikeout([doc.Str("strikeout")]) |> snapshot_with_inline("strikeout")
}

pub fn inline_code_test() {
  doc.Code(doc.Attributes("", [], []), "code")
  |> snapshot_with_inline("inline code")
}

pub fn inline_math_test() {
  doc.Math(doc.InlineMath, "x^2")
  |> snapshot_with_inline("inline math")
}

pub fn span_test() {
  doc.Span(doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Str("span text"),
  ])
  |> snapshot_with_inline("span")
}

pub fn link_test() {
  doc.Link(
    doc.Attributes("", [], []),
    [doc.Str("link text")],
    doc.Target("https://example.com", "title"),
  )
  |> snapshot_with_inline("link")
}

pub fn small_caps_test() {
  doc.SmallCaps([doc.Str("small caps")])
  |> snapshot_with_inline("small caps")
}

pub fn quoted_double_test() {
  doc.Quoted(doc.DoubleQuote, [doc.Str("double quoted")])
  |> snapshot_with_inline("double quoted")
}

pub fn quoted_single_test() {
  doc.Quoted(doc.SingleQuote, [doc.Str("single quoted")])
  |> snapshot_with_inline("single quoted")
}
