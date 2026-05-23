import pandi as doc
import pandi/filter

fn main() {
  let increase_header_level: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Header(level, _, _) ->
        filter.remove |> filter.append(doc.Header(..block, level: level + 1))
      _ -> filter.keep
    }
  }
  let ordered_to_bullet_list: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.OrderedList(_, items) ->
        filter.remove |> filter.append(doc.BulletList(items))
      _ -> filter.keep
    }
  }
  let horizontal_line_before_subheadings = fn(block, _meta) { todo }
  let remove_comment_divs: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Div(doc.Attributes(_, ["comment"], _), _) -> filter.remove
      _ -> filter.keep
    }
  }
  let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("Gleam") -> filter.keep |> filter.prepend(doc.Str("⭐️"))
      _ -> filter.keep
    }
  }
}
