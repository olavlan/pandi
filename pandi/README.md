# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

## Motivating example

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

1. Remove lines starting with *//*
2. Add a link "Open in Gleam playground" in a new paragraph after each Gleam code block.
3. Replace words *hex:[package_name]* with a link pointing to the Hex Docs of the package.

For the first two actions we need a *block filter*, and for the last actions we need an *inline filter*:

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
  |> pandoc.render("./src/examples/gleam_markdown/example.html")
}
```

The produced html will render (more or less) like this:

<iframe>
<h1 id="gleam-is-cool">Gleam is cool</h1>
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
<code>io</code> and the rest of the standard library.</p>
</iframe>

## What you need to implement yourself

### `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format. That means:

* To parse any document format, you need to call `pandoc` to convert to json first.
* To render to any document format, you need to call `pandoc` to convert from json.

The above example uses the following `pandoc` wrapper:

```gleam
import pandi.{type Document, from_json, to_json}
import shellout
import simplifile

pub fn parse_raw(raw_document: String, format: String) -> Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = from_json(result)
  document
}

pub fn render_raw(document: Document, format: String) -> String {
  let json = to_json(document)
  let cmd = "echo '" <> json <> "' | pandoc -f json -t " <> format
  let assert Ok(html) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  html
}

pub fn parse(input_path: String) -> Document {
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-t", "json", input_path],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
  let assert Ok(document) = from_json(result)
  document
}

pub fn render(document: Document, output_path: String) -> String {
  let json = to_json(document)
  let json_file_path = "./" <> output_path <> ".json"
  let assert Ok(_) = simplifile.write(to: json_file_path, contents: json)
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-f", "json", "-o", output_path, json_file_path],
      in: ".",
      opt: [],
    )
  result
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
  echo compressed_code
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
