import gleam/io
import gleam/option.{None, Some}
import in
import pandi as pd

pub fn main() {
  let increase_header_level: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.Header(level, attrs, content) ->
        Some([pd.Header(level + 1, attrs, content)])
      _ -> None
    }
  }

  let assert Ok(json_input) = in.read_chars(1_000_000)
  let assert Ok(document) = pd.from_json(json_input)
  document
  |> pd.filter_blocks(increase_header_level)
  |> pd.to_json
  |> io.println
}
