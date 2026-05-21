# pandi

[![Package Version](https://img.shields.io/hexpm/v/pandi)](https://hex.pm/packages/pandi)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pandi/)

[Pandoc filters](https://pandoc.org/filters.html) in Gleam.

Pandoc allows you to process documents in a format-independent way.

This package's goal is to make it easy to process Pandoc-compatible documents.

As an example, consider the following Markdown document:

````md
{{./examples/src/examples/resources/example.md}}
````

We can now create the following processor:

```gleam
{{./examples/src/examples/gleam_markdown.gleam}}
```

The produced html will render like this:

---

{{./examples/src/examples/resources/example.html}}

---

## What you need to implement yourself

### `pandoc` wrapper

This library deliberately does not call `pandoc`, but works with its json output format. That means:

* To parse any document format, you need to call `pandoc` to convert to json first.
* To render to any document format, you need to call `pandoc` to convert from json to the desired format.

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
