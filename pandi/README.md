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

---

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

---

In this example we have hidden away some details.
