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
  header(1)
  |> snapshot("header level 1")
}

pub fn header2_test() {
  header(2)
  |> snapshot("header level 2")
}

pub fn header3_test() {
  header(3)
  |> snapshot("header level 3")
}

pub fn header4_test() {
  header(4)
  |> snapshot("header level 4")
}

pub fn header5_test() {
  header(5)
  |> snapshot("header level 5")
}

pub fn header6_test() {
  header(6)
  |> snapshot("header level 6")
}

pub fn bullet_list_test() {
  pd.BulletList([list_item(), list_item()])
  |> snapshot("bullet list with two simple items")
}

pub fn ordered_list_test() {
  let list_attributes = pd.ListAttributes(1, pd.Decimal, pd.Period)
  pd.OrderedList(list_attributes, [list_item(), list_item()])
  |> snapshot("ordered list with two items (start=1, decimal, period)")
}

fn header(level: Int) -> pd.Block {
  pd.Header(level, empty_attributes(), [pd.Str("Header")])
}

pub fn code_block_test() {
  pd.CodeBlock(empty_attributes(), "let x = 1")
  |> snapshot("code block with inline code")
}

fn list_item() -> List(pd.Block) {
  [pd.Plain([pd.Str("Item")])]
}

fn empty_attributes() -> pd.Attributes {
  pd.Attributes("", [], [])
}
