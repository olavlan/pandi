# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to:

* Convert Pandoc documents to Lustre html
* Allow custom rendering by pattern matching on document elements

Example:

```gleam
{{examples/src/examples/increase_header_level.gleam}}
```

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc`  in order to work with specific document formats:

```gleam
{{examples/src/examples/pandoc.gleam}}
```
