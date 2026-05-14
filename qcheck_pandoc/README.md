# qcheck_pandoc

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

Pandoc allows you to work with documents in a format-independent way.

This package's goal is to generate random Pandoc documents, which can be converted to any format and used  for property testing:

```gleam
import pandi
import qcheck
import qcheck_pandoc.{document_generator}

pub fn main() {
  let seed = qcheck.random_seed()
  let #(docs, _) = qcheck.generate(document_generator(), 1, seed)
  let assert [doc] = docs
  doc |> pandi.to_json
}
```

Note that the package only works with Pandoc's JSON output, so your application will need to call `pandoc` in order to work with specific document formats:

```gleam

```
