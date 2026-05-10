pub type Meta =
  List(#(String, String))

pub type Attributes {
  Attributes(
    id: String,
    classes: List(String),
    keyvalues: List(#(String, String)),
  )
}

pub type Block {
  Header(level: Int, attributes: Attributes, content: List(Inline))
  Para(content: List(Inline))
  Plain(content: List(Inline))
  CodeBlock(attributes: Attributes, text: String)
  Div(attributes: Attributes, content: List(Block))
  BulletList(items: List(List(Block)))
}

pub type Inline {
  Str(content: String)
  Space
  Span(attributes: Attributes, content: List(Inline))
  Link(attributes: Attributes, content: List(Inline), target: Target)
}

pub type Target {
  Target(url: String, title: String)
}

pub type Document {
  Document(blocks: List(Block), meta: Meta)
}
