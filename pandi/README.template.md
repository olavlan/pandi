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

There is a bit you have to implement yourself for this to work - see the next section for details.
For now, let's see how the produced html renders:

---

{{./examples/resources/example.html}}

---

Note that we only process top-level document blocks in this example, and no inlines (words, links etc.).
If you need more advanced processing, [pandoc-filter](/pandoc_filter/README.md) provides an easy way to create document filters, i.e. functions that are applied to the whole document tree.

## What you need to implement yourself

### A `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format.
That means your application must call `pandoc` to bridge the gap between json and the desired document formats.

The above example uses the following generic `pandoc` wrapper that works on files:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

Every application needs different way of handling files, errors, and the different targets.
It's out of this library's scope to provide a generic solution to this.

### Constructing elements

This library deliberately does not expose convenience functions for constructing elements.
The type constructors are meant to be fully usable for both pattern matching and element construction.

The above example uses the following helpers to construct the links:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```
