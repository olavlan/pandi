# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package aims to:

* Convert Pandoc documents to Lustre html
* Allow custom conversion rules (through pattern matching on document elements)

As an example, consider the following Markdown document:

````md
Here is a #gleam tag, which should be converted to a link pointing to /tags/gleam.

The following should be converted to a details element:

::: my-class

# This is the summary

This is the summary with a #lustre tag.
:::
````

This is how we can convert the document to Lustre html with custom conversion rules:

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
  //     There is
  //     <a href="/tags/lustre">
  //       #lustre
  //     </a>
  //     tag in the details.
  //   </p>
  // </details>
}
```

See the Hex Docs for more details on custom conversion. See the next section for how to integrate your application with Pandoc.

## Adding a Pandoc wrapper

For importing Pandoc documents, `pandoc_lustre_converter` depends on [`pandi`]() (link coming), which deliberately doesn't try to run Pandoc, but works with its json output format instead.
That means your application must run Pandoc in order to bridge the gap between json and the desired document formats.

The above example defines the following `pandoc` module for importing a document from file:

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

`pandi` deliberately doesn't try to run Pandoc, but works with its json output format instead.
That means your application must run Pandoc in order to bridge the gap between json and the desired document formats.

The example defines the following `pandoc` module for working with files:

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
Alternatively, you can convert documents to json separately from your Gleam application.
