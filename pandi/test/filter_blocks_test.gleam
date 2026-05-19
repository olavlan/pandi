import birdie
import pandi as doc

fn snapshot(blocks: List(doc.Block), filter: doc.BlockFilter, title: String) {
  doc.Document(blocks, [])
  |> doc.filter_blocks(filter)
  |> doc.to_string
  |> birdie.snap(title: "[filter_blocks] " <> title)
}

pub fn increase_header_level_test() {
  let blocks = [
    doc.Header(1, doc.Attributes("", [], []), [doc.Str("Header")]),
    doc.Para([
      doc.Str("Paragraph"),
      doc.Space,
      doc.Str("below"),
      doc.Space,
      doc.Str("header."),
    ]),
  ]
  let filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Header(level, attrs, content) ->
        doc.remove |> doc.append(doc.Header(level + 1, attrs, content))
      _ -> doc.keep
    }
  }
  snapshot(blocks, filter, "increase header level from 1 to 2")
}

pub fn remove_comment_paragraphs_test() {
  let blocks = [
    doc.Para([
      doc.Str("//"),
      doc.Space,
      doc.Str("This is a comment"),
    ]),
    doc.Para([
      doc.Str("Normal"),
      doc.Space,
      doc.Str("paragraph."),
    ]),
    doc.Para([
      doc.Str("//"),
      doc.Space,
      doc.Str("Another comment"),
    ]),
  ]
  let filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Para([doc.Str("//"), ..]) -> doc.remove
      _ -> doc.keep
    }
  }
  snapshot(blocks, filter, "remove paragraphs starting with //")
}

pub fn convert_ordered_list_to_bullet_list_test() {
  let list_attrs = doc.ListAttributes(1, doc.Decimal, doc.Period)
  let blocks = [
    doc.OrderedList(list_attrs, [
      [doc.Para([doc.Str("First")])],
      [doc.Para([doc.Str("Second")])],
      [doc.Para([doc.Str("Third")])],
    ]),
    doc.Para([
      doc.Str("After"),
      doc.Space,
      doc.Str("the"),
      doc.Space,
      doc.Str("list."),
    ]),
  ]
  let filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.OrderedList(_, items) ->
        doc.remove |> doc.append(doc.BulletList(items))
      _ -> doc.keep
    }
  }
  snapshot(blocks, filter, "convert ordered list to bullet list")
}
