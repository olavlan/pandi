import birdie
import lustre/element.{to_readable_string}
import pandi/lustre.{block_to_lustre}
import pandi/pandoc as pd

fn snapshot(block: pd.Block, title: String) {
  block_to_lustre(block)
  |> to_readable_string
  |> birdie.snap(title: "[to_lustre_block] " <> title)
}

pub fn paragraph_test() {
  pd.Para([pd.Str("Paragraph")])
  |> snapshot("paragraph")
}

pub fn header1_test() {
  pd.Header(1, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 1")
}

pub fn header2_test() {
  pd.Header(2, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 2")
}

pub fn header3_test() {
  pd.Header(3, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 3")
}

pub fn header4_test() {
  pd.Header(4, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 4")
}

pub fn header5_test() {
  pd.Header(5, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 5")
}

pub fn header6_test() {
  pd.Header(6, pd.Attributes("", [], []), [pd.Str("Header")])
  |> snapshot("header level 6")
}

pub fn bullet_list_test() {
  pd.BulletList([
    [pd.Plain([pd.Str("Item")])],
    [pd.Plain([pd.Str("Item")])],
  ])
  |> snapshot("bullet list with two simple items")
}

pub fn ordered_list_test() {
  let list_attributes = pd.ListAttributes(1, pd.Decimal, pd.Period)
  pd.OrderedList(list_attributes, [
    [pd.Plain([pd.Str("Item")])],
    [pd.Plain([pd.Str("Item")])],
  ])
  |> snapshot("ordered list with two items (start=1, decimal, period)")
}

pub fn code_block_test() {
  pd.CodeBlock(pd.Attributes("", [], []), "let x = 1")
  |> snapshot("code block with inline code")
}

pub fn block_quote_test() {
  pd.BlockQuote([
    pd.Para([pd.Str("Quote")]),
  ])
  |> snapshot("block quote with one paragraph")
}

pub fn plain_test() {
  pd.Plain([pd.Str("Plain text")])
  |> snapshot("plain text")
}

pub fn div_test() {
  pd.Div(pd.Attributes("", [], []), [
    pd.Para([pd.Str("Inside div")]),
  ])
  |> snapshot("div with paragraph")
}

pub fn div_with_attributes_test() {
  let attrs =
    pd.Attributes("my-id", ["class1", "class2"], [#("data-foo", "bar")])
  pd.Div(attrs, [
    pd.Para([pd.Str("Styled div")]),
  ])
  |> snapshot("div with id, classes, and keyvalue attributes")
}

pub fn header_with_attributes_test() {
  let attrs =
    pd.Attributes("section-title", ["heading", "main"], [#("data-level", "top")])
  pd.Header(2, attrs, [pd.Str("Attributed Header")])
  |> snapshot("header level 2 with id, classes, and keyvalue attributes")
}

pub fn code_block_with_attributes_test() {
  let attrs =
    pd.Attributes("code-1", ["language-gleam"], [#("data-executable", "true")])
  pd.CodeBlock(attrs, "fn hello() { \"Hello\" }")
  |> snapshot("code block with id, class, and keyvalue attributes")
}

pub fn bullet_list_nested_test() {
  pd.BulletList([
    [
      pd.Para([pd.Str("Parent 1")]),
      pd.BulletList([
        [pd.Plain([pd.Str("Child 1.1")])],
        [pd.Plain([pd.Str("Child 1.2")])],
      ]),
    ],
    [pd.Para([pd.Str("Parent 2")])],
  ])
  |> snapshot("bullet list with nested sublist")
}

pub fn ordered_list_different_styles_test() {
  let roman_attrs = pd.ListAttributes(5, pd.LowerRoman, pd.OneParen)
  pd.OrderedList(roman_attrs, [
    [pd.Plain([pd.Str("Five")])],
    [pd.Plain([pd.Str("Six")])],
  ])
  |> snapshot("ordered list starting at 5 with lower roman and one paren")
}

pub fn ordered_list_upper_alpha_test() {
  let attrs = pd.ListAttributes(1, pd.UpperAlpha, pd.TwoParens)
  pd.OrderedList(attrs, [
    [pd.Plain([pd.Str("First")])],
    [pd.Plain([pd.Str("Second")])],
  ])
  |> snapshot("ordered list with upper alpha and two parens delimiter")
}

pub fn block_quote_multiple_blocks_test() {
  pd.BlockQuote([
    pd.Para([pd.Str("First paragraph")]),
    pd.Para([pd.Str("Second paragraph")]),
    pd.BulletList([
      [pd.Plain([pd.Str("List item in quote")])],
    ]),
  ])
  |> snapshot("block quote with multiple blocks including list")
}

pub fn header_default_level() {
  pd.Header(0, pd.Attributes("", [], []), [pd.Str("Level 0 header")])
  |> snapshot("header level 0 defaults to h1")
}

pub fn list_item_with_multiple_blocks_test() {
  pd.BulletList([
    [
      pd.Para([pd.Str("Title")]),
      pd.Para([pd.Str("Description")]),
      pd.CodeBlock(pd.Attributes("", [], []), "code in list"),
    ],
  ])
  |> snapshot("bullet list item with multiple blocks")
}
