import gleam/io
import gleam/option.{None, Some}
import in
import pandi
import pandi/filter.{type BlockFilter}
import pandi/pandoc as pd

pub fn main() {
  let assert Ok(json_input) = in.read_chars(1_000_000)

  let assert Ok(document) = pandi.from_json(json_input)

  let increase_header_level: BlockFilter = fn(block, _meta) {
    case block {
      pd.Header(level, attrs, content) ->
        Some([pd.Header(level + 1, attrs, content)])
      _ -> None
    }
  }

  document
  |> filter.filter_blocks(increase_header_level)
  |> pandi.to_json
  |> io.println
}
