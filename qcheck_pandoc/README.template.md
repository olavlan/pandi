# qcheck_pandoc

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to generate random Pandoc documents, which can be converted to any format and used  for property testing:

```gleam
{{examples/src/examples/generate_document.gleam}}
```
