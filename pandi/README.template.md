# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi`'s goal is to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Let's say we want to add a paragraph after each Gleam code block linking to the [Gleam playground](https://playground.gleam.run/), and then convert the document to html.
We can achieve this with Pandoc and `pandi`:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

We'll explain the imported `pandoc` and `element` modules in the next sections.
For now, here is the rendered html:

---

{{./examples/resources/example.html}}

---

## Adding a Gleam wrapper for Pandoc

`pandi` deliberately doesn't try to run Pandoc, but works with its json output format.
That means your application must run Pandoc in order to bridge the gap between json and the desired document formats.

The example defines the following generic `pandoc` module for working with document files:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling, or you can wrap Pandoc in a different way.
Alternatively, you can convert documents to Pandoc's json separately from your Gleam application.

## More advanced processing with filters

Taking the example a step further, assume we have the following Markdown document:

````md
{{./examples/resources/example-2.md}}
````

In addition to adding the Playground link after the (now nested) code block, we'd like to replace `docs:gleam_stdlib` with a link to the Hex documentation.

The `pandi/filter` module makes this easy with the concept of *document filters*.
A filter is simply an element-processing function that can be applied to all elements in the document tree:

```gleam
{{./examples/src/examples/gleam_markdown_with_filter.gleam}}
```

Note that we separate between block and inline filters for type safety.
Since block changes might overwrite inline changes, inline filters are typically applied last.

Here is the rendered html:

---

{{./examples/resources/example-2.html}}

---

## Element construction

`pandi` only exposes one convenience function to construct elements; the `text` function.
Otherwise, the type constructors are used directly.

The above examples uses an `element` module which defines the following helpers:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```

*The complete working examples exists [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you also have `pandoc` installed. These examples targets Javascript because a library is used to compress the Gleam code (for the Playground link)*.
