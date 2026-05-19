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

* Removes lines starting with *//*
* Adds a link "Open in Gleam playground" after each Gleam code block.
* Replaces words *hex:[package_name]* with a link pointing to the Hex Docs of the package.

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

When running this code, we get the following Markdown document:

````md
{{./examples/src/examples/gleam_markdown/example_processed.md}}
````

Since we are backed by `pandoc` we can convert to and from most document formats.
For intance, the html output would render (more or less) like this:

---

{{./examples/src/examples/gleam_markdown/example_processed.md}}

---

In this example we have hidden away some details.
