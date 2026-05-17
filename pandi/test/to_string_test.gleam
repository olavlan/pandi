import birdie
import pandi as pd

fn snapshot_block(block: pd.Block, title: String) {
  pd.Document([block], [])
  |> pd.to_string
  |> birdie.snap(title: "[to_string] " <> title)
}

pub fn paragraph_test() {
  pd.Para([pd.Str("Paragraph")])
  |> snapshot_block("paragraph with one string element")
}

pub fn header_test() {
  pd.Header(
    1,
    pd.Attributes("my-id", ["class1"], [#("key", "value")]),
    [pd.Str("Header text")],
  )
  |> snapshot_block("level 1 header")
}

pub fn plain_test() {
  pd.Plain([pd.Str("Plain text")])
  |> snapshot_block("plain block")
}

pub fn code_block_test() {
  pd.CodeBlock(
    pd.Attributes("my-id", ["class1"], [#("key", "value")]),
    "let x = 1",
  )
  |> snapshot_block("code block with attributes")
}

pub fn div_test() {
  pd.Div(
    pd.Attributes("my-id", ["class1"], [#("key", "value")]),
    [pd.Para([pd.Str("Inside div")])],
  )
  |> snapshot_block("div with paragraph")
}

pub fn bullet_list_test() {
  pd.BulletList([
    [pd.Para([pd.Str("Item 1")])],
    [pd.Para([pd.Str("Item 2")])],
  ])
  |> snapshot_block("bullet list with two items")
}

pub fn ordered_list_test() {
  pd.OrderedList(
    pd.ListAttributes(1, pd.Decimal, pd.Period),
    [
      [pd.Para([pd.Str("First")])],
      [pd.Para([pd.Str("Second")])],
    ],
  )
  |> snapshot_block("ordered list starting at 1")
}

pub fn block_quote_test() {
  pd.BlockQuote([
    pd.Para([pd.Str("Quoted text")]),
  ])
  |> snapshot_block("block quote with paragraph")
}
