# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi`'s goal is to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Let's say we want to add a paragraph after each Gleam code block linking to the [Gleam playground](https://playground.gleam.run/), and then convert the document to html.
We can achieve this in the following way:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

As you can tell by the imports, there is a bit more we need for this to work; see the next section for details.
For now, let's see how the produced html will render:

---

{{./examples/resources/example.html}}

---

Details:

* The example needs a `pandoc` wrapper to work; see the next subsection.
* The example only processes top-level document elements; see the second subsection on how to extend this with the `pandi/filter` module.
* The type constructors for creating elements are quite verbose, so the example uses some helpers; see the last subsection for details.

## Adding a `pandoc` wrapper

`pandi` deliberately doesn't try to run `pandoc`, but works with its json output format.
That means your application must run `pandoc` in order to bridge the gap between json and the desired document formats.

The given example defines the following generic `pandoc` wrapper that works for files on disk:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling, or you can wrap `pandoc` in a different way.
Alternatively, the conversion of documents to json can happen separately from your Gleam application.

## Using filters

Taking the example a step further, assume that we have the following Markdown document:

````md
{{./examples/resources/example-with-nesting.md}}
````

Note that the code block is nested in a bullet list.

In addition to adding the Playground link, we'd like to replace `docs:gleam_stdlib` with a link to the Hex documentation.
The `pandi/filter` module provides a way to define *filters*, which can be applied to the whole document tree:

```gleam
{{./examples/src/examples/gleam_markdown_with_filter.gleam}}
```

The produced html will render as expected:

---

{{./examples/resources/example-with-nesting.html}}

---

## Element construction

`pandi` does not expose convenience functions to construct elements; the type constructors are used directly.

The examples use the following helpers to construct the links:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```

*The complete working examples exists [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you have `pandoc` installed. These examples targets Javascript because it's needed to compress the Gleam code in the Markdown examples (for the Playground link)*.
