# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

`pandi` aims to make it easy to create [Pandoc](https://pandoc.org/)-backed document processors.

As an example, consider the following Markdown document:

````md
{{./examples/resources/example.md}}
````

Here is how we can process code blocks with `pandi`:

```gleam
{{./examples/src/examples/gleam_markdown_example.gleam}}
```

We'll explain the helper modules in the next sections.
For now, here is the rendered html:

---

{{./examples/resources/example.html}}

---

## Integrating with Pandoc

`pandi` can only import Pandoc's generic json format.
If you want to import specific document formats, you have to call Pandoc with the output set to `json`,
and then import the result:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be extended with proper file and error handling.
Alternatively, you can convert documents to json separately from your Gleam application.

## More advanced processing with filters

Taking the example a step further, assume we have the following Markdown document:

````md
{{./examples/resources/example-2.md}}
````

These nested elements can be processed with *filters*, using the `pandi/filter` module.
A filter is an element-processing function that can be applied to the whole document tree:

```gleam
{{./examples/src/examples/gleam_markdown_example_with_filter.gleam}}
```

Note that we distinguish between block and inline filters for type safety.
Inline filters are typically applied last so they're not overwritten by block filters.

Here is the rendered html:

---

{{./examples/resources/example-2.html}}

---

## Element construction

`pandi` only exposes one convenience function to construct elements; the `doc.text` function.
Otherwise, the type constructors in the `doc` module are used directly:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

*The complete working examples exist [here](https://github.com/olavlan/pandi/tree/main/pandi/examples) as a Gleam project, and should work as long as you have `pandoc` installed. These examples target Javascript because a Javascript library is used to compress the Gleam code (for the Playground link)*.
