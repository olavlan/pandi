import birdie
import pandi as pd

fn snapshot(blocks: List(pd.Block), filter: pd.BlockFilter, title: String) {
  pd.Document(blocks, [])
  |> pd.filter_blocks(filter)
  |> pd.to_string
  |> birdie.snap(title: "[filter_blocks] " <> title)
}

pub fn increase_header_level_test() {
  let blocks = [
    pd.Header(1, pd.Attributes("", [], []), [pd.Str("Header")]),
    pd.Para([
      pd.Str("Paragraph"),
      pd.Space,
      pd.Str("below"),
      pd.Space,
      pd.Str("header."),
    ]),
  ]
  let filter: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.Header(level, attrs, content) ->
        pd.Replace(pd.Header(level + 1, attrs, content))
      _ -> pd.Keep
    }
  }
  snapshot(blocks, filter, "increase header level from 1 to 2")
}

pub fn remove_comment_paragraphs_test() {
  let blocks = [
    pd.Para([
      pd.Str("//"),
      pd.Space,
      pd.Str("This is a comment"),
    ]),
    pd.Para([
      pd.Str("Normal"),
      pd.Space,
      pd.Str("paragraph."),
    ]),
    pd.Para([
      pd.Str("//"),
      pd.Space,
      pd.Str("Another comment"),
    ]),
  ]
  let filter: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.Para([pd.Str("//"), ..]) -> pd.Remove
      _ -> pd.Keep
    }
  }
  snapshot(blocks, filter, "remove paragraphs starting with //")
}

pub fn convert_ordered_list_to_bullet_list_test() {
  let list_attrs = pd.ListAttributes(1, pd.Decimal, pd.Period)
  let blocks = [
    pd.OrderedList(list_attrs, [
      [pd.Para([pd.Str("First")])],
      [pd.Para([pd.Str("Second")])],
      [pd.Para([pd.Str("Third")])],
    ]),
    pd.Para([
      pd.Str("After"),
      pd.Space,
      pd.Str("the"),
      pd.Space,
      pd.Str("list."),
    ]),
  ]
  let filter: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.OrderedList(_, items) -> pd.Replace(pd.BulletList(items))
      _ -> pd.Keep
    }
  }
  snapshot(blocks, filter, "convert ordered list to bullet list")
}
