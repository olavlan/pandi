# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

## Motivating example

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

<iframe>
{{./examples/src/examples/gleam_markdown/example.html}}
</iframe>

## What you need to implement yourself

### `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format. That means:

* To parse any document format, you need to call `pandoc` to convert to json first.
* To render to any document format, you need to call `pandoc` to convert from json.

The above example uses the following `pandoc` wrapper:

```gleam
{{./examples/src/examples/pandoc.gleam}}
```

This can be used as a starting point for creating a wrapper with appropriate file and error handling.

### Constructing elements

This library deliberately does not expose convenience functions for constructing elements.
The type constructors are meant to be fully usable for both pattern matching and element construction.

The above example uses the following helpers to construct the links:

```gleam
{{./examples/src/examples/gleam_markdown/element.gleam}}
```
