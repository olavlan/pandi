# Gleam-specific instructions

## Development

This project is a Gleam implementation of pandocfilters with support for converting to Lustre html.

This segment from the Python version  of pandocfilters gives a reference to what we need to implement:

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

However, we want more useful typed constructors.

The best reference for the raw, JSON-serialized pandoc AST format is to run `just md-to-pandoc` with a minimal markdown example.
For a reference on how to create a markdown example, use <https://pandoc.org/MANUAL.html#pandocs-markdown>.
A good reference for the AST types we want is the Lua implementation: <https://pandoc.org/lua-filters.html#pandoc-functions>

## Coding style

* Always prefer readability and explicitness over abstraction.
* Use few and repeated patterns in each module. Functions that look similar improves readability.
