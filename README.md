Gleam packages for working with Pandoc documents:

* [pandi](#pandi): core package with Pandoc filters.
* [pandoc-lustre-converter]: Pandoc to Lustre generator, with rendering hooks.
* [qcheck-pandoc]: Pandoc document generator.

---

# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to work with documents in a format-independent way. 

This package's goal is to make it easy to work with Pandoc documents:

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

Note that the package only works with Pandoc's JSON output, so your application will need to call ´pandoc´ in order to work with various document formats:

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

