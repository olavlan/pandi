# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package's goal is to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Assume we want to add a paragraph after each Gleam code block linking to the [Gleam playground](https://playground.gleam.run/), and then convert to html.
We can achieve this in the following way:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

There is a bit you have to implement yourself for this to work; see the next section for details.
For now, let's see how the produced html renders:

---

{{./examples/resources/example.html}}

---

Note that we only processed top-level document blocks and no inlines (words, links etc.).
If you need more advanced processing, [pandoc-filter](/pandoc_filter/README.md) provides an opinionated way to create and run document filters, i.e. functions that are applied to the whole document tree.

## What needs to be implemented

### A `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format.
That means your application must call `pandoc` in order to bridge the gap between json and the desired document formats.

The above example uses the following generic `pandoc` wrapper for files on disk:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

Every application needs different ways of handling files, errors, and the different targets.
It's out of this library's scope to provide a generic solution to this.

### Element construction

The above example uses the following helpers to construct the playground link:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```
