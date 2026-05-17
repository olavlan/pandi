import birdie
import lustre/element.{to_readable_string}
import pandi as pd
import pandoc_lustre_converter.{convert_blocks}

fn snapshot(block: pd.Block, title: String) {
  convert_blocks([block])
  |> to_readable_string
  |> birdie.snap(title: "[convert_blocks] " <> title)
}

pub fn paragraph_test() {
  pd.Para([pd.Str("Paragraph")])
  |> snapshot("paragraph with one string element")
}

pub fn header_test() {
  pd.Header(1, pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Str("Header text"),
  ])
  |> snapshot("level 1 header")
}

pub fn plain_test() {
  pd.Plain([pd.Str("Plain text")])
  |> snapshot("plain block")
}

pub fn code_block_test() {
  pd.CodeBlock(
    pd.Attributes("my-id", ["class1"], [#("key", "value")]),
    "let x = 1",
  )
  |> snapshot("code block with attributes")
}

pub fn div_test() {
  pd.Div(pd.Attributes("my-id", ["class1"], [#("key", "value")]), [
    pd.Para([pd.Str("Inside div")]),
  ])
  |> snapshot("div with paragraph")
}

pub fn bullet_list_test() {
  pd.BulletList([
    [pd.Para([pd.Str("Item 1")])],
    [pd.Para([pd.Str("Item 2")])],
  ])
  |> snapshot("bullet list with two items")
}

pub fn ordered_list_test() {
  pd.OrderedList(pd.ListAttributes(1, pd.Decimal, pd.Period), [
    [pd.Para([pd.Str("First")])],
    [pd.Para([pd.Str("Second")])],
  ])
  |> snapshot("ordered list starting at 1")
}

pub fn block_quote_test() {
  pd.BlockQuote([
    pd.Para([pd.Str("Quoted text")]),
  ])
  |> snapshot("block quote with paragraph")
}
