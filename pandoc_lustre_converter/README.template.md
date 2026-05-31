# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package's goal is to:

* Convert Pandoc documents to Lustre html
* Allow custom conversion rules through pattern matching on document elements

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

This is how we can convert the document to Lustre html with custom conversion rules:

```gleam
{{./examples/src/examples/custom_converters_with_file.gleam}}
```

See the Hex Docs for details.

One thing to note is that you need a wrapper TODO
