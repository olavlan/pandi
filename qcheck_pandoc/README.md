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
