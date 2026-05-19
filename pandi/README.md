# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

As an example, consider the following Markdown document:

````md

Gleam is cool!

//TODO write some cool stuff about Gleam here

Here is a *Hello world* example:

```gleam
import gleam/io

pub fn main() {
  io.println("Hello world!")
}
```

Go to hex:gleam_stdlib to learn more about the standard library.
````

We can now create the following processor:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc

pub fn main() {
  let block_filter: doc.BlockFilter = fn(block, _meta) {
    case block {
      // remove "comment" lines:
      doc.Para([doc.Str("//" <> _), ..]) -> doc.remove
      // append a gleam playground link to each code block:
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        doc.keep |> doc.append(element.gleam_playground_link(code))
      // keep all other inlines (children are still subject to filter)
      _ -> doc.keep
    }
  }

  let inline_filter: doc.InlineFilter = fn(inline, _meta) {
    case inline {
      // replace all occurrences of "hex:[package_name] with a link to the Hex docs:"
      doc.Str("hex:" <> package_name) ->
        doc.remove |> doc.append(element.hex_link(package_name))
      // keep all other inlines
      _ -> doc.keep
    }
  }

  pandoc.parse(from_file: "example.md", from_format: "markdown")
  |> doc.filter_blocks(block_filter)
  |> doc.filter_inlines(inline_filter)
  |> pandoc.render(to_file: "example.html", to_format: "html")
}
```

The produced html will render like this:

---

<p>Gleam is cool!</p>
<p>Here is a <em>Hello world</em> example:</p>
<div class="sourceCode" id="cb1"><pre
class="sourceCode gleam"><code class="sourceCode gleam"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="im">gleam/io</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="kw">pub</span> <span class="kw">fn</span> <span class="fu">main</span><span class="op">()</span> <span class="op">{</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a>  io<span class="op">.</span><span class="fu">println</span><span class="op">(</span><span class="st">&quot;Hello world!&quot;</span><span class="op">)</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><a
href="https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBHQDuNJgBMAhAfm8AviGdA"
title="Gleam playground">Open code in Gleam playground</a></p>
<p>Go to <a href="https://hexdocs.pm/gleam_stdlib/index.html"
title="gleam_stdlib at Hex Docs">gleam_stdlib</a> to learn more about
the standard library.</p>

---

## What you need to implement yourself

### `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format. That means:

* To parse any document format, you need to call `pandoc` to convert to json first.
* To render to any document format, you need to call `pandoc` to convert from json to the desired format.

The above example uses the following `pandoc` wrapper:

```gleam
import pandi as doc
import shellout
import simplifile

const document_folder = "src/examples/resources/"

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

This can be used as a starting point for creating a wrapper with appropriate file and error handling.

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
