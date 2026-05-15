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
import lustre/element.{to_readable_string}
import pandoc_lustre_converter.{convert_document}

pub fn main() {
  let header =
    "# Header"
    |> parse("markdown")
    |> convert_document
    |> to_readable_string
  assert header == "<h2 id=\"header\">\n  Header\n</h1>\n"
}
```

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc`  in order to work with specific document formats:

```gleam
import pandi.{type Document, from_json}
import shellout

pub fn parse(raw_document: String, format: String) -> Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = from_json(result)
  document
}
```
