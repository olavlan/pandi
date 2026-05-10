pub type Meta =
  List(#(String, String))

pub type Attributes {
  Attributes(
    id: String,
    classes: List(String),
    keyvalues: List(#(String, String)),
  )
}

pub type ListNumberStyle {
  Decimal
  LowerAlpha
  UpperAlpha
  LowerRoman
  UpperRoman
}

pub type ListNumberDelimiter {
  Period
  OneParen
  TwoParens
}

pub type ListAttributes {
  ListAttributes(
    start: Int,
    style: ListNumberStyle,
    delimiter: ListNumberDelimiter,
  )
}

pub type Block {
  Header(level: Int, attributes: Attributes, content: List(Inline))
  Para(content: List(Inline))
  Plain(content: List(Inline))
  CodeBlock(attributes: Attributes, text: String)
  Div(attributes: Attributes, content: List(Block))
  BulletList(items: List(List(Block)))
  OrderedList(
    attributes: ListAttributes,
    items: List(List(Block)),
  )
}

pub type Inline {
  Str(content: String)
  Space
  Emph(content: List(Inline))
  Strong(content: List(Inline))
  Strikeout(content: List(Inline))
  Code(attributes: Attributes, text: String)
  Span(attributes: Attributes, content: List(Inline))
  Link(attributes: Attributes, content: List(Inline), target: Target)
}

pub type Target {
  Target(url: String, title: String)
}

pub type Document {
  Document(blocks: List(Block), meta: Meta)
}
