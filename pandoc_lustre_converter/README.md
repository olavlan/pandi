# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to:

* Convert Pandoc documents to Lustre html
* Allow custom rendering by pattern matching on document elements

Example:

```gleam
import examples/pandoc
import lustre/element
import pandoc_lustre_converter as converter

pub fn main() {
  let header =
    "# Header"
    |> pandoc.parse("markdown")
    |> converter.convert_document
    |> element.to_readable_string
  assert header == "<h1 id=\"header\">\n  Header\n</h1>\n"
}
```

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc`  in order to work with specific document formats:

```gleam
import pandi/doc
import shellout

pub fn parse(raw_document: String, format: String) -> doc.Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = doc.from_json(result)
  document
}
```
