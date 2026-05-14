Gleam packages for working with Pandoc documents:

* [pandi](#pandi): core package with Pandoc filters.
* [pandoc_lustre_converter](#pandoc_lustre_converter): Pandoc to Lustre converter, with rendering hooks.
* [qcheck_pandoc](#qcheck_pandoc): Pandoc random document generator.

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

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc`  in order to work with specific document formats:

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

---

# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to:

* Convert Pandoc documents to Lustre html
* Allow custom rendering by pattern matching on document elements

Example:

```gleam
import examples/pandoc.{parse}
import gleam/option.{None, Some}
import pandoc_lustre_converter

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

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc`  in order to work with specific document formats:

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
```

---

# qcheck_pandoc

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to generate random Pandoc documents, which can be converted to any format and used  for property testing:

```gleam
import examples/pandoc.{parse, render}
import gleam/io
import qcheck
import qcheck_pandoc.{document_generator}

pub fn main() {
  let seed = qcheck.random_seed()
  let #(docs, _) = qcheck.generate(document_generator(), 1, seed)
  let assert [doc] = docs
  doc |> pandi.to_json |> render("markdown") |> io.println
}

fn markdown_processor() {
  todo
}
```

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc` in order to work with specific document formats:

```gleam
import pandi.{type Document, from_json, to_json}
import shellout

pub fn render(document: Document, format: String) -> String {
  let json = to_json(document)
  let cmd = "echo '" <> json <> "' | pandoc -f json -t " <> format
  let assert Ok(html) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  html
}
```
