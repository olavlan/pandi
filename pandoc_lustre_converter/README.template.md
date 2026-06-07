# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package builds on [pandi](https://olavlan.github.io/pandi/pandi/) and aims to support:

* Converting a [Pandoc document](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Document) to a [Lustre element](https://lustre.hexdocs.pm/lustre/element.html#Element).
* Custom conversion rules through pattern matching on [block](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Block) and [inline](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Inline) document elements.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Here is how we can convert it using a mix of default and custom conversion:

```gleam
{{./examples/src/examples/custom_converters_with_file.gleam}}
```

See the [module docs](https://olavlan.github.io/pandi/pandoc_lustre_converter/pandoc_lustre_converter.html) for more details on custom conversion.
See the next section on how to integrate your Gleam/Lustre application with Pandoc.

## Integrating with [Pandoc](https://pandoc.org/)

`pandoc_lustre_converter` depends on `pandi`, which can only import Pandoc's generic json format.
If you want to import specific document formats, you have to call Pandoc with output set to `json`, and then import the result.

As a starting point, here is the `pandoc` helper module used by the above example:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling.
Alternatively, you can convert documents to json separately from your Gleam/Lustre application.

*The complete example exists as a Gleam project [here](https://github.com/olavlan/pandi/tree/main/pandoc_lustre_converter/examples) along with other examples. Running it requires Pandoc to be installed.*
