# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

```sh
gleam add pandi@1
```

```gleam
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
```

```sh
echo '# Hello' | pandoc -f markdown -t json | gleam run -m example | pandoc -f json -t html
# <h2 id="hello">Hello</h2>
```

Further documentation can be found at <https://hexdocs.pm/pandi>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
