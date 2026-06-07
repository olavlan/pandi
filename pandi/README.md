# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi` aims to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md

We want to add a link to the *Gleam Playground* after this code block:

```gleam
import gleam/io

pub fn main() {
  io.println("Hello, world!")
}
```
````

Here is how we can process the code blocks with `pandi`:

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

We'll explain the helper modules `pandoc` and `element` in the next sections.
For now, here is the rendered html:

---

<p>We want to add a link to the <em>Gleam Playground</em> after this
code block:</p>
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

## Integrating with Pandoc

`pandi` can only import Pandoc's generic json format.
If you want to import specific document formats, you have to call Pandoc with output set to `json`, and then import the result.

As a starting point, here is the `pandoc` helper module used by the above example:

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

This can be extended with proper file and error handling.
Alternatively, you can convert documents to json separately from your Gleam application.

## More advanced processing with filters

Taking the example a step further, assume we have the following Markdown document:

````md

A list:

* We want to add a link to the *Gleam Playground* after this nested code block:

  ```gleam
  import gleam/io

  pub fn main() {
    io.println("Hello, world!")
  }
  ```

* We want docs:lustre to become a link to the Hex Docs.
````

In this case we need to process nested elements.
This can be done with *filters*, using the `pandi/filter` module.
A filter is an element-processing function that can be applied to the whole document tree:

```gleam
import examples/gleam_markdown/element
import examples/pandoc
import pandi/doc
import pandi/filter

pub fn main() {
  let add_playground_link_to_codeblocks: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.CodeBlock(doc.Attributes(_, ["gleam"], _), code) ->
        [element.gleam_playground_link(code)] |> filter.append
      _ -> filter.keep
    }
  }

  let create_hex_docs_links: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("docs:" <> package_name) ->
        [element.hex_link(package_name)] |> filter.replace
      _ -> filter.keep
    }
  }

  pandoc.file_to_document(from_file: "example-2.md", from_format: "markdown")
  |> filter.apply_block_filter(add_playground_link_to_codeblocks)
  |> filter.apply_inline_filter(create_hex_docs_links)
  |> pandoc.document_to_file(to_file: "example-2.html", to_format: "html")
}
```

Note that we distinguish between block and inline filters for type safety.
Inline filters are typically applied last so they're not overwritten by block filters.

Here is the rendered html:

---

<p>A list:</p>
<ul>
<li><p>We want to add a link to the <em>Gleam Playground</em> after this
nested code block:</p>
<div class="sourceCode" id="cb1"><pre
class="sourceCode gleam"><code class="sourceCode gleam"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">import</span> <span class="im">gleam/io</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="kw">pub</span> <span class="kw">fn</span> <span class="fu">main</span><span class="op">()</span> <span class="op">{</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true" tabindex="-1"></a>  io<span class="op">.</span><span class="fu">println</span><span class="op">(</span><span class="st">&quot;Hello, world!&quot;</span><span class="op">)</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><a
href="https://playground.gleam.run/#N4IgbgpgTgzglgewHYgFwEYA0IDGyAuES+aIcAtgA4JT4AEA5gDYQCG5A9IgDpK+UBXAEZ0AZkjrlWcJAAoAlHWC86dRADpKUGfiZzuIABIQmTBJjoB3GkwAmAQgPzeAXxAugA=="
title="Gleam playground">Open code in Gleam playground 🔗</a></p></li>
<li><p>We want <a href="https://hexdocs.pm/lustre/index.html"
title="lustre at Hex Docs">lustre 🔗</a> to become a link to the Hex
Docs.</p></li>
</ul>

---

## Element construction

`pandi` only exposes one convenience function to construct elements; the `doc.text` function.
Otherwise, the type constructors in the `doc` module are used directly.

The above example defines the following `element` module:

```gleam
import pandi/doc

pub fn hex_link(package_name: String) -> doc.Inline {
  let url = "https://hexdocs.pm/" <> package_name <> "/index.html"
  let title = package_name <> " at Hex Docs"
  doc.Link(
    attributes: empty_attributes(),
    target: doc.Target(url: url, title: title),
    content: [
      doc.Str(package_name),
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

*The complete working examples exist [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you have `pandoc` installed. These examples target Javascript because a Javascript library is used to compress the Gleam code (for the Playground link)*.
