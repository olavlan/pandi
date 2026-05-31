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

Some things to note are:

* A block or inline converter should return either `custom(element)` or `default`.
  In practice, the former is used for custom conversion rules, and the latter is used for the remaining patterns.
* When using `default`, the element's children are subject to custom conversion rules.
* When using `default_blocks` and `default_inlines`, the blocks/inlines are subject to custom conversion rules.  
