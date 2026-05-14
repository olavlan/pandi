# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc's abstract document representation allows you to work with documents in a format-independent way. 
.
This package's goal is to make it easy to work with an abstract Pandoc document:

```gleam
import examples/pandoc.{parse, render}
import gleam/option.{None, Some}
import pandi as pd

pub fn main() {
  let increase_header_level: pd.BlockFilter = fn(block, _meta) {
    case block {
      pd.Header(level, attrs, content) ->
        Some([pd.Header(level + 1, attrs, content)])
      _ -> None
    }
  }

  let html =
    "# Hello world"
    |> parse("markdown")
    |> pd.filter_blocks(increase_header_level)
    |> render("html")

  assert html == "<h2 id=\"hello-world\">Hello world</h2>\n"
}
```

Note that it's necessary to create your own wrappers to the `pandoc` executable, since the package itself only works with JSON-serialized Pandoc documents: 

```gleam
import pandi.{type Document, from_json, to_json}
import shellout

pub fn parse(raw_document: String, format: String) -> Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = from_json(result)
  document
}

pub fn render(document: Document, format: String) -> String {
  let json = to_json(document)
  let cmd = "echo '" <> json <> "' | pandoc -f json -t " <> format
  let assert Ok(html) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  html
}
```

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
