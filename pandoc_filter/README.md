# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi`'s goal is to make it easy to create advanced [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md

Gleam is **cool**:

* *Hello world* example:

  ```gleam
  import gleam/io

  pub fn main() {
    io.println("Hello, world!")
  }
  ```

* Visit `docs:gleam_stdlib` to learn more about the standard library.
````

Let's say we want to add a paragraph after each Gleam code block linking to the [Gleam playground](https://playground.gleam.run/), and then convert the document to html.
We can achieve this in the following way:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import pandi as doc
import pandoc_filter as filter

pub fn main() {
  let block_filter: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        filter.keep |> filter.append(element.gleam_playground_link(code))
      _ -> filter.keep
    }
  }

  let inline_filter: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Code(_, "docs:" <> package_name) ->
        filter.remove |> filter.append(element.hex_link(package_name))
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> filter.filter_blocks(block_filter)
  |> filter.filter_inlines(inline_filter)
  |> pandoc.document_to_file(to_file: "example.html", to_format: "html")
}
```

There is a bit that you have to implement yourself for this to work; see the next section for details.
For now, let's see how the produced html will render:

---

<p>Gleam is <strong>cool</strong>:</p>
<ul>
<li><p><em>Hello world</em> example:</p>
<div class="sourceCode" id="cb1"><pre
class="sourceCode gleam"><code class="sourceCode gleam"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="im">gleam/io</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="kw">pub</span> <span class="kw">fn</span> <span class="fu">main</span><span class="op">()</span> <span class="op">{</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a>  io<span class="op">.</span><span class="fu">println</span><span class="op">(</span><span class="st">&quot;Hello, world!&quot;</span><span class="op">)</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><a
href="https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBJjoB3GkwAmAQgPzeAXxAugA=="
title="Gleam playground">Open code in Gleam playground 🔗</a></p></li>
<li><p>Visit <a href="https://hexdocs.pm/gleam_stdlib/index.html"
title="gleam_stdlib at Hex Docs"><code>gleam_stdlib</code></a> to learn
more about the standard library.</p></li>
</ul>

---

Here we have only processed top-level block elements, but no nested block elements or inline elements (words, links etc.).
If you need more advanced processing, document filters should be used; they are functions that are applied to all elements in the document tree.
[pandoc-filter](https://olavlan.github.io/pandi/pandoc_filter/) provides an opinionated way to do this with `pandi`.

## What needs to be implemented

### A `pandoc` wrapper

`pandi` deliberately does not call `pandoc`, but works with its json output format.
That means your application must call `pandoc` in order to bridge the gap between json and the desired document formats.

The given example defines the following generic `pandoc` wrapper that works for files on disk:

```gleam
import pandi as doc
import shellout
import simplifile

const document_folder = "resources/"

pub fn file_to_document(
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

pub fn document_to_file(
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

Adding proper file and error handling to this example could be enough for many applications.

### Element construction

`pandi` does not expose convenience functions to construct elements; the type constructors are used directly.

The given example defines the following helpers to construct the playground link:

```gleam
import gleam/list
import gleam/string
import pandi as doc

pub fn hex_link(package_name: String) -> doc.Inline {
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  doc.Link(
    attributes: empty_attributes(),
    target: doc.Target(url: url, title: title),
    content: [
      doc.Code(attributes: empty_attributes(), text: package_name),
    ],
  )
}

pub fn gleam_playground_link(gleam_code: String) -> doc.Block {
  let url = "https://playground.gleam.run/#" <> make_v1_hash(gleam_code)
  doc.Para(content: [
    doc.Link(
      attributes: empty_attributes(),
      target: doc.Target(url: url, title: "Gleam playground"),
      content: text("Open code in Gleam playground 🔗"),
    ),
  ])
}

pub fn text(text: String) -> List(doc.Inline) {
  string.split(text, on: " ")
  |> list.map(doc.Str)
  |> list.intersperse(doc.Space)
}

fn empty_attributes() -> doc.Attributes {
  doc.Attributes(id: "", classes: [], keyvalues: [])
}

@external(javascript, "./lz_ffi.mjs", "makeV1Hash")
fn make_v1_hash(code: String) -> String
```

*The complete working example exists [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you have `pandoc` installed.*
