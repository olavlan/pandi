import gleam/list
import pandi/doc
import pandi/filter

pub fn main() {
  let increase_header_level: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Header(level, ..) ->
        [doc.Header(..block, level: level + 1)] |> filter.replace
      _ -> filter.keep
    }
  }
  let remove_comment_lines: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Para([doc.Str("//" <> _), ..]) -> filter.remove
      _ -> filter.keep
    }
  }
  let ordered_to_bullet_list: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.OrderedList(_, items) -> [doc.BulletList(items)] |> filter.replace
      _ -> filter.keep
    }
  }
  let remove_comment_divs: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.Div(doc.Attributes(_, ["comment"], _), _) -> filter.remove
      _ -> filter.keep
    }
  }
  let prepend_gleam_star: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("Gleam") -> doc.text("⭐️ ") |> filter.prepend
      _ -> filter.keep
    }
  }
  let include_link_symbol: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Link(_, content, _) ->
        [doc.Link(..inline, content: list.append(content, doc.text(" 🔗")))]
        |> filter.replace
      _ -> filter.keep
    }
  }
  let run_code = fn(_code: String) -> String { "mock result" }
  let append_code_result: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(_, code) ->
        [doc.Para(doc.text(run_code(code)))] |> filter.append
      _ -> filter.keep
    }
  }
  #(
    remove_comment_lines,
    increase_header_level,
    ordered_to_bullet_list,
    remove_comment_divs,
    prepend_gleam_star,
    include_link_symbol,
    append_code_result,
  )
}
