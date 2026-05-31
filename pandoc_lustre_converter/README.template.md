# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package aims to:

* Convert [Pandoc](https://www.pandoc.org/) documents to Lustre html
* Allow custom conversion rules through pattern matching on document elements

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Let's convert this to Lustre html with some custom conversion rules:

```gleam
{{./examples/src/examples/custom_converters_with_file.gleam}}
```

See the [Hex Docs]() (link coming) for more details on custom conversion.
See the next section on how to integrate your Gleam/Lustre application with Pandoc.

## Integrating with Pandoc

`pandoc_lustre_converter` uses the document type defined in the [`pandi`]() package.
`pandi` can only import a document from Pandoc's json format.
To import from a Markdown file, your application must run Pandoc to convert it to json first.

The above example defines a helper module `pandoc` import documents from files:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling, or you can wrap Pandoc in a different way.
Alternatively, you can convert documents to json separately from your Gleam/Lustre application.

*The complete example exists as a Gleam project [here](https://github.com/olavlan/pandi/tree/main/pandoc_lustre_converter/examples) along with other examples. Running it requires Pandoc to be installed.*
