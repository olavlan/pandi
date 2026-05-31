# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package aims to:

* Convert Pandoc documents to Lustre html
* Allow custom conversion rules through pattern matching on document elements

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Let's convert this to Lustre html with custom conversion rules:

```gleam
{{./examples/src/examples/custom_converters_with_file.gleam}}
```

See the [Hex Docs]() (link coming) for more details on custom conversion.
See the next section for how to integrate your Gleam/Lustre application with Pandoc.

## Integrating with Pandoc

For importing Pandoc documents, `pandoc_lustre_converter` depends on [`pandi`]() (link coming), which does not try to run Pandoc, but works with its json output format instead.
That means your application must run Pandoc in order to bridge the gap between json and the desired document formats.

The above example defines the following `pandoc` module that import documents from files:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling, or you can wrap Pandoc in a different way.
Alternatively, you can convert documents to json separately from your Gleam/Lustre application.
