# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package aims to:

* Convert [Pandoc](https://www.pandoc.org/) documents to Lustre html
* Allow custom conversion rules through pattern matching on document elements

As an example, consider the following Markdown document:

````md
Here is a #gleam tag, which should be converted to a link pointing to /tags/gleam.

The following should be converted to a details element:

::: my-class

# This is the summary

These are the details, including a #lustre tag.
:::
````

Let's convert this to Lustre html with some custom conversion rules:

```gleam
import examples/pandoc
import gleam/io
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as pl

pub fn main() {
  let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(attributes, [doc.Header(_, _, inlines), ..rest]) -> {
        use details <- pl.default_blocks(rest)
        use summary <- pl.default_inlines(inlines)
        html.details(pl.convert_attributes(attributes), [
          html.summary([], [summary]),
          details,
        ])
        |> pl.custom
      }
      _ -> pl.default
    }
  }

  let inline_converter: pl.InlineConverter(msg) = fn(inline, _meta) {
    case inline {
      doc.Str("#" <> tag) ->
        html.a([attr.href("/tags/" <> tag)], [html.text("#" <> tag)])
        |> pl.custom
      _ -> pl.default
    }
  }

  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> pl.convert_document(block_converter, inline_converter)
  |> element.to_readable_string
  |> io.println
  // <p>
  //   Here is a
  //   <a href="/tags/gleam">
  //     #gleam
  //   </a>
  //   tag, which should be converted to a link pointing to /tags/gleam.
  // </p>
  // <p>
  //   The following should be converted to a details element:
  // </p>
  // <details class="my-class">
  //   <summary>
  //     This is the summary
  //   </summary>
  //   <p>
  //     These are the details, including a
  //     <a href="/tags/lustre">
  //       #lustre
  //     </a>
  //     tag.
  //   </p>
  // </details>
}
```

See the [Hex Docs]() (link coming) for more details on custom conversion.
See the next section on how to integrate your Gleam/Lustre application with Pandoc.

## Integrating with Pandoc

`pandoc_lustre_converter` uses the document type defined in the [`pandi`]() package.
`pandi` can only import a document from Pandoc's json format.
To import from a Markdown file, your application must run Pandoc to convert it to json first.

The above example defines a helper module `pandoc` import documents from files:

```gleam
import pandi/doc
import shellout

const folder = "resources/"

pub fn file_to_document(
  from_file filename: String,
  from_format from_format: String,
) -> doc.Document {
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-f", from_format, "-t", "json", folder <> filename],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
  let assert Ok(document) = doc.from_json(result)
  document
}
```

This can be extended with proper file and error handling, or you can wrap Pandoc in a different way.
Alternatively, you can convert documents to json separately from your Gleam/Lustre application.

*The complete example exists as a Gleam project [here](https://github.com/olavlan/pandi/tree/main/pandoc_lustre_converter/examples) along with other examples. Running it requires Pandoc to be installed.*
