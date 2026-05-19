# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

As an example, consider the following Markdown document:

````md
# Gleam is cool

//TODO write some cool stuff about Gleam here

Here is a *Hello world* example:

```gleam
import gleam/io

pub fn main() {
  io.println("Hello world!")
}
```

Go to hex:gleam_stdlib to learn more about `io` and the rest of the standard library.
````

A document processor for Gleam articles could do the following:

* Removes lines starting with *//*
* Adds a link "Open in Gleam playground" after each Gleam code block.
* Replaces words *hex:[package_name]* with a link pointing to the Hex Docs of the package.

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        doc.keep |> doc.append(element.gleam_playground_link(code))
      _ -> doc.keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("hex:" <> package_name) ->
        doc.remove |> doc.append(element.hex_link(package_name))
      _ -> doc.keep
    }
  }

  pandoc.parse("./src/examples/gleam_markdown/example.md")
  |> doc.filter_blocks(block_filter)
  |> doc.filter_inlines(inline_filter)
  |> pandoc.render("./src/examples/gleam_markdown/example_processed.md")
}
```

When running this code, we get the following Markdown document:

````md
# Gleam is cool

Here is a *Hello world* example:

``` gleam
import gleam/io

pub fn main() {
  io.println("Hello world!")
}
```

[Open code in Gleam playground](https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBHQDuNJgBMAhAfm8AviGdA "Gleam playground")

Go to
[gleam_stdlib](https://hexdocs.pm/gleam_stdlib/index.html "gleam_stdlib at Hex Docs")
to learn more about `io` and the rest of the standard library.
````

Since we are backed by `pandoc` we can convert to and from most document formats.
For intance, the html output would render (more or less) like this:

---

# Gleam is cool

Here is a *Hello world* example:

``` gleam
import gleam/io

pub fn main() {
  io.println("Hello world!")
}
```

[Open code in Gleam playground](https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBHQDuNJgBMAhAfm8AviGdA "Gleam playground")

Go to
[gleam_stdlib](https://hexdocs.pm/gleam_stdlib/index.html "gleam_stdlib at Hex Docs")
to learn more about `io` and the rest of the standard library.

---

In this example we have hidden away some details.
