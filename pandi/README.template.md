# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

This package's goal is to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Let's say we want to add a paragraph after each Gleam code block linking to the [Gleam playground](https://playground.gleam.run/), and then convert the document to html.
We can achieve this in the following way:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

There is a bit that you have to implement yourself for this to work; see the next section for details.
For now, let's see how the produced html will render:

---

{{./examples/resources/example.html}}

---

Here we have only processed top-level document blocks, but no nested blocks inlines (words, links etc.).
If you need more advanced processing, document filters can be used; they are functions that are applied to all elements in the document tree.
[pandoc-filter](/pandoc_filter) provides an opinionated way to do this with `pandi`.

## What needs to be implemented

### A `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format.
That means your application must call `pandoc` in order to bridge the gap between json and the desired document formats.

The above example uses the following generic `pandoc` wrapper that works for files on disk:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

Adding proper file and error handling to this example could be enough for many applications.

### Element construction

The above example uses the following helpers to construct the playground link:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```
