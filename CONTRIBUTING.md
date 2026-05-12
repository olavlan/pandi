# Contributing

This project is a Gleam implementation of [Pandoc filters](https://pandoc.org/filters.html) with support for converting to a [Lustre html tree](https://hexdocs.pm/lustre/lustre/element/html.html).

## Pandoc document AST

This [Python version](github.com/jgm/pandocfilters/blob/master/pandocfilters.py) of Pandoc filters provides a short reference to what we need to implement. The important part is:

```py
def elt(eltType, numargs):
    def fun(*args):
        lenargs = len(args)
        if lenargs != numargs:
            raise ValueError(eltType + ' expects ' + str(numargs) +
                             ' arguments, but given ' + str(lenargs))
        if numargs == 0:
            xs = []
        elif len(args) == 1:
            xs = args[0]
        else:
            xs = list(args)
        return {'t': eltType, 'c': xs}
    return fun

# Constructors for block elements

Plain = elt('Plain', 1)
Para = elt('Para', 1)
CodeBlock = elt('CodeBlock', 2)
RawBlock = elt('RawBlock', 2)
BlockQuote = elt('BlockQuote', 1)
OrderedList = elt('OrderedList', 2)
BulletList = elt('BulletList', 1)
DefinitionList = elt('DefinitionList', 1)
Header = elt('Header', 3)
HorizontalRule = elt('HorizontalRule', 0)
Table = elt('Table', 5)
Div = elt('Div', 2)
Null = elt('Null', 0)
Figure = elt('Figure', 3)

# Constructors for inline elements

Str = elt('Str', 1)
Emph = elt('Emph', 1)
Strong = elt('Strong', 1)
Strikeout = elt('Strikeout', 1)
Superscript = elt('Superscript', 1)
Subscript = elt('Subscript', 1)
SmallCaps = elt('SmallCaps', 1)
Quoted = elt('Quoted', 2)
Cite = elt('Cite', 2)
Code = elt('Code', 2)
Space = elt('Space', 0)
LineBreak = elt('LineBreak', 0)
Math = elt('Math', 2)
RawInline = elt('RawInline', 2)
Link = elt('Link', 3)
Image = elt('Image', 3)
Note = elt('Note', 1)
SoftBreak = elt('SoftBreak', 0)
Span = elt('Span', 2)
```

Here we see the number of argument for each type in the document AST.
However, we want more useful constructors similar to the [Lua implementation](https://pandoc.org/lua-filters.html#pandoc-functions).

We want to parse the JSON-serialized document AST.
While there is no official schema, we can understand the structure of the different element types by running `just md-to-pandoc` with a minimal markdown example.
Markdown examples should follow the [Pandoc markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) variant.
The Lua implementation above should elso be used for a reference to the possible values of fields.

## Checklist for adding support for an element type

Code:

* Type constructor
* Decoder
* Encoder
* Handling of the element type in the filter (if it has nested elements)
* Handling of the element in the Lustre conversion
  * Note: we should use Pandoc's html output as a reference
* A generator to be used by the document generator
  * Note: we want to ensure the document generator generates readable document samples

Tests:

* A minimal `from_json` snapshot test (follow existing examples)
  * Note: Example is written as a markdown file and converted to JSON using `just resources`
* A minimal `to_lustre` snapshot test (follow existing examples)

Note that all snapshot tests must be reviewed manually (by a human)
