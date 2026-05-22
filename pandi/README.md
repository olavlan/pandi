# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.
This package's goal is to make it easy to create a Pandoc-backed document processors.

As an example, consider the following Markdown document:

````md

````

Assume we want to add a paragraph after every Gleam code block linking to the playground.
We can achieve this in the following way:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import gleam/list
import pandi as doc

pub fn main() {
  pandoc.parse(from_file: "example.md", from_format: "markdown")
  |> filter_top_level_blocks
  |> pandoc.render(to_file: "example.html", to_format: "html")
}

fn filter_top_level_blocks(document: doc.Document) -> doc.Document {
  let new_blocks = list.flat_map(document.blocks, filter_block)
  doc.Document(..document, blocks: new_blocks)
}

fn filter_block(block: doc.Block) -> List(doc.Block) {
  case block {
    doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) -> [
      block,
      element.gleam_playground_link(code),
    ]
    _ -> [block]
  }
}
```

There is a bit you have to implement yourself for this to work - see the next section for details.
For now, this is how the produced html renders:

---



---

## What you need to implement yourself

### A `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format.
That means your application must call `pandoc` to bridge the gap between json and the desired document formats.

The above example uses the following generic `pandoc` wrapper that works on files:

```gleam
import pandi as doc
import shellout
import simplifile

const document_folder = "resources/"

pub fn parse(
  from_file filename: String,
  from_format from_format: String,
) -> doc.Document {
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-f", from_format, "-t", "json", document_folder <> filename],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
  let assert Ok(document) = doc.from_json(result)
  document
}

pub fn render(
  document: doc.Document,
  to_file filename: String,
  to_format to_format,
) {
  let json_file = document_folder <> filename <> ".json"
  let assert Ok(_) =
    simplifile.write(to: json_file, contents: doc.to_json(document))
  let assert Ok(_) =
    shellout.command(
      run: "pandoc",
      with: [
        "-f",
        "json",
        "-t",
        to_format,
        "-o",
        document_folder <> filename,
        json_file,
      ],
      in: ".",
      opt: [],
    )
  let assert Ok(_) = simplifile.delete(json_file)
}
```

Every application needs different file and error handling, and handling of the different targets.
It's out of this library's scope to provide a generic solution to this.

### Constructing elements

This library deliberately does not expose convenience functions for constructing elements.
The type constructors are meant to be fully usable for both pattern matching and element construction.

The above example uses the following helpers to construct the links:

```gleam
import pandi as doc

pub fn hex_link(package_name: String) -> doc.Inline {
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  basic_link(url: url, title: title, text: package_name)
}

pub fn gleam_playground_link(gleam_code: String) -> doc.Block {
  let compressed_code = make_v1_hash(gleam_code)
  let url = "https://playground.gleam.run/#" <> compressed_code
  doc.Para(content: [
    basic_link(
      url: url,
      title: "Gleam playground",
      text: "Open code in Gleam playground",
    ),
  ])
}

fn basic_link(
  url url: String,
  title title: String,
  text text: String,
) -> doc.Inline {
  doc.Link(
    attributes: doc.Attributes(id: "", classes: [], keyvalues: []),
    target: doc.Target(url: url, title: title),
    content: [doc.Str(text)],
  )
}

@external(javascript, "./lz_ffi.mjs", "makeV1Hash")
fn make_v1_hash(code: String) -> String
```
