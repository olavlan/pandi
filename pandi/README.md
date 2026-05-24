# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi`'s goal is to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md

Gleam is **cool** - here is a *Hello world* example:

```gleam
import gleam/io

pub fn main() {
  io.println("Hello, world!")
}
```
````

Let's say we want to link to the [Gleam playground](https://playground.gleam.run/) after each code block, and then convert the document to html.
We can achieve this with Pandoc and `pandi`:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import gleam/list
import pandi/doc

fn process_block(block: doc.Block) -> List(doc.Block) {
  case block {
    doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) -> [
      block,
      element.gleam_playground_link(code),
    ]
    _ -> [block]
  }
}

fn process_top_level_blocks(document: doc.Document) -> doc.Document {
  let new_blocks = list.flat_map(document.blocks, process_block)
  doc.Document(..document, blocks: new_blocks)
}

pub fn main() {
  pandoc.file_to_document(from_file: "example.md", from_format: "markdown")
  |> process_top_level_blocks
  |> pandoc.document_to_file(to_file: "example.html", to_format: "html")
}
```

We'll explain the imported `pandoc` and `element` modules in the next sections.
For now, here is the rendered html:

---

<p>Gleam is <strong>cool</strong> - here is a <em>Hello world</em>
example:</p>
<div class="sourceCode" id="cb1"><pre
class="sourceCode gleam"><code class="sourceCode gleam"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="im">gleam/io</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="kw">pub</span> <span class="kw">fn</span> <span class="fu">main</span><span class="op">()</span> <span class="op">{</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a>  io<span class="op">.</span><span class="fu">println</span><span class="op">(</span><span class="st">&quot;Hello, world!&quot;</span><span class="op">)</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><a
href="https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBJjoB3GkwAmAQgPzeAXxAugA=="
title="Gleam playground">Open code in Gleam playground 🔗</a></p>

---

## Adding a Gleam wrapper for Pandoc

`pandi` deliberately doesn't try to run Pandoc, but works with its json output format.
That means your application must run Pandoc in order to bridge the gap between json and the desired document formats.

The example defines the following generic `pandoc` module for working with files:

```gleam
import pandi/doc
import shellout
import simplifile

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

pub fn document_to_file(
  document: doc.Document,
  to_file filename: String,
  to_format to_format,
) {
  let json_file = folder <> filename <> ".json"
  let assert Ok(_) =
    simplifile.write(to: json_file, contents: doc.to_json(document))
  let assert Ok(_) =
    shellout.command(
      run: "pandoc",
      with: ["-f", "json", "-t", to_format, "-o", folder <> filename, json_file],
      in: ".",
      opt: [],
    )
  let assert Ok(_) = simplifile.delete(json_file)
}
```

This can be extended with proper file and error handling, or you can wrap Pandoc in a different way.
Alternatively, you can convert documents to Pandoc's json separately from your Gleam application.

## More advanced processing with filters

Taking the example a step further, assume we have the following Markdown document:

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

We still want to add the Playground link after the (now nested) code block, and additionally replace occurrences of  `docs:[package_name]` with a link to the Hex documentation.

The `pandi/filter` module makes this easy with the concept of *document filters*.
A filter is an element-processing function that can be applied to all elements in the document tree:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import pandi/doc
import pandi/filter

pub fn main() {
  let block_filter: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        [element.gleam_playground_link(code)] |> filter.append
      _ -> filter.keep
    }
  }

  let inline_filter: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Code(_, "docs:" <> package_name) ->
        [element.hex_link(package_name)] |> filter.replace
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(from_file: "example-2.md", from_format: "markdown")
  |> filter.filter_blocks(block_filter)
  |> filter.filter_inlines(inline_filter)
  |> pandoc.document_to_file(to_file: "example-2.html", to_format: "html")
}
```

Note that we separate between block and inline filters for type safety.
Inline filters are typically applied last so they're not overwritten by the block filters.

Here is the rendered html:

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
title="gleam_stdlib at Hex Docs"><code>gleam_stdlib</code> 🔗</a> to
learn more about the standard library.</p></li>
</ul>

---

## Element construction

`pandi` only exposes one convenience function to construct elements; the `text` function.
Otherwise, the type constructors are used directly.

The examples defines an `element` module with the following helpers:

```gleam
import pandi/doc

pub fn hex_link(package_name: String) -> doc.Inline {
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  doc.Link(
    attributes: empty_attributes(),
    target: doc.Target(url: url, title: title),
    content: [
      doc.Code(attributes: empty_attributes(), text: package_name),
      doc.Space,
      doc.Str("🔗"),
    ],
  )
}

pub fn gleam_playground_link(gleam_code: String) -> doc.Block {
  let url = "https://playground.gleam.run/#" <> make_v1_hash(gleam_code)
  doc.Para(content: [
    doc.Link(
      attributes: empty_attributes(),
      target: doc.Target(url: url, title: "Gleam playground"),
      content: doc.text("Open code in Gleam playground 🔗"),
    ),
  ])
}

fn empty_attributes() -> doc.Attributes {
  doc.Attributes(id: "", classes: [], keyvalues: [])
}

@external(javascript, "./lz_ffi.mjs", "makeV1Hash")
fn make_v1_hash(code: String) -> String
```

*The complete working examples exists [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you have `pandoc` installed. These examples targets Javascript because a Javascript library is used to compress the Gleam code (for the Playground link)*.
