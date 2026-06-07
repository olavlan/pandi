# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package builds on [pandi](https://olavlan.github.io/pandi/pandi/) and aims to support:

* Converting a [Pandoc document](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Document) to a [Lustre element](https://lustre.hexdocs.pm/lustre/element.html#Element).
* Custom conversion rules through pattern matching on [block](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Block) and [inline](https://olavlan.github.io/pandi/pandi/pandi/doc.html#Inline) document elements.

As an example, consider the following Markdown document:

````md
Here is a #gleam tag, which should be converted to a link pointing to /tags/gleam.

The following should be converted to a details element:

::: my-class

# This is the summary

These are the details, including a #lustre tag.
:::
````

Here is how we can convert it using a mix of default and custom conversion:

```gleam
import examples/pandoc
import lustre/attribute
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
        html.a([attribute.href("/tags/" <> tag)], [html.text("#" <> tag)])
        |> pl.custom
      _ -> pl.default
    }
  }

  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> pl.convert_document(block_converter, inline_converter)
  |> element.to_readable_string
  |> echo
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

See the [module docs](https://olavlan.github.io/pandi/pandoc_lustre_converter/pandoc_lustre_converter.html) for more details on custom conversion.
See the next section on how to integrate your Gleam/Lustre application with Pandoc.

## Integrating with [Pandoc](https://pandoc.org/)

`pandoc_lustre_converter` depends on `pandi`, which can only import Pandoc's generic json format.
If you want to import specific document formats, you have to call Pandoc with output set to `json`, and then import the result.

As a starting point, here is the `pandoc` helper module used by the above example:

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

This can be extended with proper file and error handling.
Alternatively, you can convert documents to json separately from your Gleam/Lustre application.

*The complete example exists as a Gleam project [here](https://github.com/olavlan/pandi/tree/main/pandoc_lustre_converter/examples) along with other examples. Running it requires Pandoc to be installed.*
