# pandoc-lustre-converter

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package's goal is to:

* Convert Pandoc documents to Lustre html
* Allow custom conversion rules through pattern matching on document elements

As an example, consider the following Markdown document:

````md
There is a #gleam tag this paragraph,
which should be converted to a link to /tags/gleam.

The following should be converted to a details element:

::: details

# This is the summary

There is #lustre tag in the details.
:::
````

This is how we can convert the document to Lustre html with custom conversion rules:

```gleam
import examples/pandoc
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import pandi/doc
import pandoc_lustre_converter as pl

pub fn main() {
  let block_converter: pl.BlockConverter(msg) = fn(block, _meta) {
    case block {
      doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
        use details <- pl.default_blocks(rest)
        use summary <- pl.default_inlines(inlines)
        html.details([], [
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
        html.a([attr.href("/tags/" <> tag)], [html.text(tag)]) |> pl.custom
      _ -> pl.default
    }
  }

  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> pl.convert_document(block_converter, inline_converter)
  |> element.to_readable_string
  // <p>
  //   There is a
  //   <a href="/tags/gleam">
  //     gleam
  //   </a>
  //   tag this paragraph, which should be converted to a link to /tags/gleam.
  // </p>
  // <p>
  //   The following should be converted to a details element:
  // </p>
  // <details>
  //   <summary>
  //     This is the summary
  //   </summary>
  //   <p>
  //     There is
  //     <a href="/tags/lustre">
  //       lustre
  //     </a>
  //     tag in the details.
  //   </p>
  // </details>
}
```

See the Hex Docs for details.

One thing to note is that you need a wrapper TODO
