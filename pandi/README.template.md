# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

As an example, consider the following Markdown document:

````md
{{./examples/src/examples/gleam_markdown/example.md}}
````

A document processor for Gleam articles could do the following:

1. Remove lines starting with *//*
2. Add a link "Open in Gleam playground" in a new paragraph after each Gleam code block.
3. Replace words *hex:[package_name]* with a link pointing to the Hex Docs of the package.

For the first two actions we need a *block filter*, and for the last actions we need an *inline filter*:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

The produced html will render (more or less) like this:

---

{{./examples/src/examples/gleam_markdown/example.html}}

---

In this example we have hidden away some details.
