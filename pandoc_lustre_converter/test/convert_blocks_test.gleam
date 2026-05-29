import birdie
import lustre/element
import pandi/doc
import pandoc_lustre_converter as pl

fn snapshot(block: doc.Block, title: String) {
  doc.Document([block], [])
  |> pl.convert_document
  |> element.to_readable_string
  |> birdie.snap(title: "[convert_blocks] " <> title)
}

pub fn paragraph_test() {
  doc.Para([doc.Str("Paragraph")])
  |> snapshot("paragraph with one string element")
}

pub fn header_test() {
  doc.Header(1, doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Str("Header text"),
  ])
  |> snapshot("level 1 header")
}

pub fn plain_test() {
  doc.Plain([doc.Str("Plain text")])
  |> snapshot("plain block")
}

pub fn code_block_test() {
  doc.CodeBlock(
    doc.Attributes("my-id", ["class1"], [#("key", "value")]),
    "let x = 1",
  )
  |> snapshot("code block with attributes")
}

pub fn div_test() {
  doc.Div(doc.Attributes("my-id", ["class1"], [#("key", "value")]), [
    doc.Para([doc.Str("Inside div")]),
  ])
  |> snapshot("div with paragraph")
}

pub fn bullet_list_test() {
  doc.BulletList([
    [doc.Plain([doc.Str("Item 1")])],
    [doc.Plain([doc.Str("Item 2")])],
  ])
  |> snapshot("bullet list with two items")
}

pub fn ordered_list_test() {
  doc.OrderedList(doc.ListAttributes(1, doc.Decimal, doc.Period), [
    [doc.Plain([doc.Str("First")])],
    [doc.Plain([doc.Str("Second")])],
  ])
  |> snapshot("ordered list starting at 1")
}

pub fn block_quote_test() {
  doc.BlockQuote([
    doc.Para([doc.Str("Quoted text")]),
  ])
  |> snapshot("block quote with paragraph")
}
