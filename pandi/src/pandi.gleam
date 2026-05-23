import glam/doc as glam
import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/list
import gleam/string

pub type Document {
  Document(blocks: List(Block), meta: Meta)
}

pub type Meta =
  List(#(String, String))

pub type Block {
  Header(level: Int, attributes: Attributes, content: List(Inline))
  Para(content: List(Inline))
  Plain(content: List(Inline))
  CodeBlock(attributes: Attributes, text: String)
  Div(attributes: Attributes, content: List(Block))
  BulletList(items: List(List(Block)))
  OrderedList(attributes: ListAttributes, items: List(List(Block)))
  BlockQuote(content: List(Block))
}

pub type Inline {
  Str(content: String)
  Space
  LineBreak
  SoftBreak
  Emph(content: List(Inline))
  Strong(content: List(Inline))
  Strikeout(content: List(Inline))
  Code(attributes: Attributes, text: String)
  Span(attributes: Attributes, content: List(Inline))
  Link(attributes: Attributes, content: List(Inline), target: Target)
}

pub type Attributes {
  Attributes(
    id: String,
    classes: List(String),
    keyvalues: List(#(String, String)),
  )
}

pub type Target {
  Target(url: String, title: String)
}

pub type ListAttributes {
  ListAttributes(
    start: Int,
    style: ListNumberStyle,
    delimiter: ListNumberDelimiter,
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

/// Create a list of inlines from a string of space-separated words. 
///
/// Example: `text("A sentence.") -> [Str("A"), Space, Str("sentence.")`.
pub fn text(text: String) -> List(Inline) {
  string.split(text, on: " ")
  |> list.map(Str)
  |> list.intersperse(Space)
}

pub fn from_json(json_string: String) -> Result(Document, json.DecodeError) {
  json.parse(from: json_string, using: document_decoder())
}

pub fn document_decoder() -> decode.Decoder(Document) {
  use blocks <- decode.field("blocks", decode.list(block_decoder()))
  use meta <- decode.field("meta", meta_decoder())
  decode.success(Document(blocks, meta))
}

fn meta_decoder() -> decode.Decoder(Meta) {
  decode.dict(decode.string, meta_value_decoder())
  |> decode.map(dict.to_list)
}

fn meta_value_decoder() -> decode.Decoder(String) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  case content {
    [Str(val)] -> decode.success(val)
    _ -> decode.failure("", "MetaInlines")
  }
}

fn block_decoder() -> decode.Decoder(Block) {
  use t <- decode.field("t", decode.string)
  case t {
    "Header" -> header_decoder()
    "Para" -> para_decoder()
    "Plain" -> plain_decoder()
    "CodeBlock" -> code_block_decoder()
    "Div" -> div_decoder()
    "BulletList" -> bullet_list_decoder()
    "OrderedList" -> ordered_list_decoder()
    "BlockQuote" -> block_quote_decoder()
    _ -> decode.failure(Para([]), "Block")
  }
}

fn header_decoder() -> decode.Decoder(Block) {
  use level <- decode_c_at(0, decode.int)
  use attributes <- decode_c_at(1, attributes_decoder())
  use content <- decode_c_at(2, decode.list(inline_decoder()))
  decode.success(Header(level, attributes, content))
}

fn para_decoder() -> decode.Decoder(Block) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  decode.success(Para(content))
}

fn plain_decoder() -> decode.Decoder(Block) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  decode.success(Plain(content))
}

fn code_block_decoder() -> decode.Decoder(Block) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use text <- decode_c_at(1, decode.string)
  decode.success(CodeBlock(attributes, text))
}

fn div_decoder() -> decode.Decoder(Block) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(block_decoder)))
  decode.success(Div(attributes, content))
}

fn bullet_list_decoder() -> decode.Decoder(Block) {
  use items <- decode.field(
    "c",
    decode.list(decode.list(decode.recursive(block_decoder))),
  )
  decode.success(BulletList(items))
}

fn ordered_list_decoder() -> decode.Decoder(Block) {
  use attrs <- decode_c_at(0, list_attributes_decoder())
  use items <- decode_c_at(
    1,
    decode.list(decode.list(decode.recursive(block_decoder))),
  )
  decode.success(OrderedList(attrs, items))
}

fn block_quote_decoder() -> decode.Decoder(Block) {
  use content <- decode.field("c", decode.list(decode.recursive(block_decoder)))
  decode.success(BlockQuote(content))
}

fn list_attributes_decoder() -> decode.Decoder(ListAttributes) {
  use start <- decode.field(0, decode.int)
  use style <- decode.field(1, list_number_style_decoder())
  use delimiter <- decode.field(2, list_number_delimiter_decoder())
  decode.success(ListAttributes(start, style, delimiter))
}

fn list_number_style_decoder() -> decode.Decoder(ListNumberStyle) {
  use t <- decode.field("t", decode.string)
  case t {
    "Decimal" -> decode.success(Decimal)
    "LowerAlpha" -> decode.success(LowerAlpha)
    "UpperAlpha" -> decode.success(UpperAlpha)
    "LowerRoman" -> decode.success(LowerRoman)
    "UpperRoman" -> decode.success(UpperRoman)
    _ -> decode.failure(Decimal, "ListNumberStyle")
  }
}

fn list_number_delimiter_decoder() -> decode.Decoder(ListNumberDelimiter) {
  use t <- decode.field("t", decode.string)
  case t {
    "Period" -> decode.success(Period)
    "OneParen" -> decode.success(OneParen)
    "TwoParens" -> decode.success(TwoParens)
    _ -> decode.failure(Period, "ListNumberDelimiter")
  }
}

fn inline_decoder() -> decode.Decoder(Inline) {
  use t <- decode.field("t", decode.string)
  case t {
    "Str" -> str_decoder()
    "Space" -> space_decoder()
    "LineBreak" -> line_break_decoder()
    "SoftBreak" -> soft_break_decoder()
    "Emph" -> emph_decoder()
    "Strong" -> strong_decoder()
    "Strikeout" -> strikeout_decoder()
    "Code" -> code_decoder()
    "Span" -> span_decoder()
    "Link" -> link_decoder()
    _ -> decode.failure(Space, "Inline")
  }
}

fn link_decoder() -> decode.Decoder(Inline) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(inline_decoder)))
  use target <- decode_c_at(2, target_decoder())
  decode.success(Link(attributes, content, target))
}

fn target_decoder() -> decode.Decoder(Target) {
  use url <- decode.field(0, decode.string)
  use title <- decode.field(1, decode.string)
  decode.success(Target(url, title))
}

fn span_decoder() -> decode.Decoder(Inline) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(inline_decoder)))
  decode.success(Span(attributes, content))
}

fn str_decoder() -> decode.Decoder(Inline) {
  use content <- decode.field("c", decode.string)
  decode.success(Str(content))
}

fn space_decoder() -> decode.Decoder(Inline) {
  decode.success(Space)
}

fn line_break_decoder() -> decode.Decoder(Inline) {
  decode.success(LineBreak)
}

fn soft_break_decoder() -> decode.Decoder(Inline) {
  decode.success(SoftBreak)
}

fn emph_decoder() -> decode.Decoder(Inline) {
  use content <- decode.field(
    "c",
    decode.list(decode.recursive(inline_decoder)),
  )
  decode.success(Emph(content))
}

fn strong_decoder() -> decode.Decoder(Inline) {
  use content <- decode.field(
    "c",
    decode.list(decode.recursive(inline_decoder)),
  )
  decode.success(Strong(content))
}

fn strikeout_decoder() -> decode.Decoder(Inline) {
  use content <- decode.field(
    "c",
    decode.list(decode.recursive(inline_decoder)),
  )
  decode.success(Strikeout(content))
}

fn code_decoder() -> decode.Decoder(Inline) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use text <- decode_c_at(1, decode.string)
  decode.success(Code(attributes, text))
}

fn attributes_decoder() -> decode.Decoder(Attributes) {
  use id <- decode.field(0, decode.string)
  use classes <- decode.field(1, decode.list(decode.string))
  use keyvalues <- decode.field(2, decode.list(keyvalue_decoder()))
  decode.success(Attributes(id, classes, keyvalues))
}

fn keyvalue_decoder() -> decode.Decoder(#(String, String)) {
  use key <- decode.field(0, decode.string)
  use value <- decode.field(1, decode.string)
  decode.success(#(key, value))
}

fn decode_c_at(
  index: Int,
  decoder: decode.Decoder(a),
  next: fn(a) -> decode.Decoder(b),
) -> decode.Decoder(b) {
  use value <- decode.field("c", decode.at([index], decoder))
  next(value)
}

pub fn to_json(doc: Document) -> String {
  doc
  |> encode_document
  |> json.to_string
}

pub fn encode_document(doc: Document) -> json.Json {
  json.object([
    #("pandoc-api-version", json.array([1, 23, 1], json.int)),
    #("meta", encode_meta(doc.meta)),
    #("blocks", json.array(doc.blocks, encode_block)),
  ])
}

fn encode_meta(meta: Meta) -> json.Json {
  meta
  |> list.map(fn(pair) { #(pair.0, encode_meta_value(pair.1)) })
  |> json.object
}

fn encode_meta_value(val: String) -> json.Json {
  json.object([
    #("t", json.string("MetaInlines")),
    #("c", json.array([Str(val)], encode_inline)),
  ])
}

fn encode_block(block: Block) -> json.Json {
  case block {
    Header(level, attributes, content) ->
      json.object([
        #("t", json.string("Header")),
        #("c", encode_header_content(level, attributes, content)),
      ])
    Para(content) ->
      json.object([
        #("t", json.string("Para")),
        #("c", json.array(content, encode_inline)),
      ])
    Plain(content) ->
      json.object([
        #("t", json.string("Plain")),
        #("c", json.array(content, encode_inline)),
      ])
    CodeBlock(attributes, text) ->
      json.object([
        #("t", json.string("CodeBlock")),
        #("c", encode_code_block_content(attributes, text)),
      ])
    Div(attributes, content) ->
      json.object([
        #("t", json.string("Div")),
        #("c", encode_div_content(attributes, content)),
      ])
    BulletList(items) ->
      json.object([
        #("t", json.string("BulletList")),
        #("c", json.array(items, encode_bullet_list_item)),
      ])
    OrderedList(attrs, items) ->
      json.object([
        #("t", json.string("OrderedList")),
        #("c", encode_ordered_list_content(attrs, items)),
      ])
    BlockQuote(content) ->
      json.object([
        #("t", json.string("BlockQuote")),
        #("c", json.array(content, encode_block)),
      ])
  }
}

fn encode_inline(inline: Inline) -> json.Json {
  case inline {
    Str(content) ->
      json.object([
        #("t", json.string("Str")),
        #("c", json.string(content)),
      ])
    Space ->
      json.object([
        #("t", json.string("Space")),
      ])
    LineBreak ->
      json.object([
        #("t", json.string("LineBreak")),
      ])
    SoftBreak ->
      json.object([
        #("t", json.string("SoftBreak")),
      ])
    Emph(content) ->
      json.object([
        #("t", json.string("Emph")),
        #("c", json.array(content, encode_inline)),
      ])
    Strong(content) ->
      json.object([
        #("t", json.string("Strong")),
        #("c", json.array(content, encode_inline)),
      ])
    Strikeout(content) ->
      json.object([
        #("t", json.string("Strikeout")),
        #("c", json.array(content, encode_inline)),
      ])
    Code(attributes, text) ->
      json.object([
        #("t", json.string("Code")),
        #("c", encode_code_content(attributes, text)),
      ])
    Span(attributes, content) ->
      json.object([
        #("t", json.string("Span")),
        #("c", encode_span_content(attributes, content)),
      ])
    Link(attributes, content, target) ->
      json.object([
        #("t", json.string("Link")),
        #("c", encode_link_content(attributes, content, target)),
      ])
  }
}

fn encode_code_content(attributes: Attributes, text: String) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.string(text),
  ])
}

fn encode_div_content(
  attributes: Attributes,
  content: List(Block),
) -> json.Json {
  let encoded_attributes = encode_attributes(attributes)
  let encoded_content = json.array(content, encode_block)

  json.preprocessed_array([encoded_attributes, encoded_content])
}

fn encode_code_block_content(
  attributes: Attributes,
  text: String,
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.string(text),
  ])
}

fn encode_span_content(
  attributes: Attributes,
  content: List(Inline),
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.array(content, encode_inline),
  ])
}

fn encode_link_content(
  attributes: Attributes,
  content: List(Inline),
  target: Target,
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.array(content, encode_inline),
    encode_target(target),
  ])
}

fn encode_target(target: Target) -> json.Json {
  json.preprocessed_array([json.string(target.url), json.string(target.title)])
}

fn encode_header_content(
  level: Int,
  attributes: Attributes,
  content: List(Inline),
) -> json.Json {
  json.preprocessed_array([
    json.int(level),
    encode_attributes(attributes),
    json.array(content, encode_inline),
  ])
}

fn encode_attributes(attrs: Attributes) -> json.Json {
  json.preprocessed_array([
    json.string(attrs.id),
    json.array(attrs.classes, json.string),
    json.array(attrs.keyvalues, encode_keyvalue),
  ])
}

fn encode_keyvalue(keyvalue: #(String, String)) -> json.Json {
  json.preprocessed_array([json.string(keyvalue.0), json.string(keyvalue.1)])
}

fn encode_bullet_list_item(item: List(Block)) -> json.Json {
  json.array(item, encode_block)
}

fn encode_ordered_list_content(
  attrs: ListAttributes,
  items: List(List(Block)),
) -> json.Json {
  json.preprocessed_array([
    encode_list_attributes(attrs),
    json.array(items, encode_bullet_list_item),
  ])
}

fn encode_list_attributes(attrs: ListAttributes) -> json.Json {
  json.preprocessed_array([
    json.int(attrs.start),
    encode_list_number_style(attrs.style),
    encode_list_number_delimiter(attrs.delimiter),
  ])
}

fn encode_list_number_style(style: ListNumberStyle) -> json.Json {
  let t = case style {
    Decimal -> "Decimal"
    LowerAlpha -> "LowerAlpha"
    UpperAlpha -> "UpperAlpha"
    LowerRoman -> "LowerRoman"
    UpperRoman -> "UpperRoman"
  }
  json.object([#("t", json.string(t))])
}

fn encode_list_number_delimiter(delim: ListNumberDelimiter) -> json.Json {
  let t = case delim {
    Period -> "Period"
    OneParen -> "OneParen"
    TwoParens -> "TwoParens"
  }
  json.object([#("t", json.string(t))])
}

pub fn to_string(document: Document) -> String {
  pretty_blocks(document.blocks)
  |> glam.to_string(80)
}

fn pretty_blocks(blocks: List(Block)) -> glam.Document {
  list.map(blocks, pretty_block)
  |> pretty_list
}

fn pretty_inlines(inlines: List(Inline)) -> glam.Document {
  list.map(inlines, pretty_inline)
  |> pretty_list
}

fn pretty_block(block: Block) -> glam.Document {
  case block {
    Header(level, attrs, content) ->
      [
        pretty_number(level),
        glam.space,
        pretty_attributes(attrs),
        glam.space,
        pretty_inlines(content),
      ]
      |> pretty_element("Header")
    Para(content) ->
      [pretty_inlines(content)]
      |> pretty_element("Para")
    Plain(content) ->
      [pretty_inlines(content)]
      |> pretty_element("Plain")
    CodeBlock(attrs, text) ->
      [pretty_attributes(attrs), glam.space, pretty_string(text)]
      |> pretty_element("CodeBlock")
    OrderedList(attrs, items) ->
      [
        pretty_list_attributes(attrs),
        glam.space,
        pretty_list(list.map(items, pretty_blocks)),
      ]
      |> pretty_element("OrderedList")
    Div(attrs, content) ->
      [pretty_attributes(attrs), glam.space, pretty_blocks(content)]
      |> pretty_element("Div")
    BulletList(items) ->
      [pretty_list(list.map(items, pretty_blocks))]
      |> pretty_element("BulletList")
    BlockQuote(content) ->
      [pretty_blocks(content)]
      |> pretty_element("BlockQuote")
  }
}

fn pretty_inline(inline: Inline) -> glam.Document {
  case inline {
    Str(text) -> [pretty_string(text)] |> pretty_element("Str")
    Space -> pretty_void_element("Space")
    Link(attrs, content, target) ->
      [
        pretty_attributes(attrs),
        glam.space,
        pretty_inlines(content),
        glam.space,
        pretty_link_target(target),
      ]
      |> pretty_element("Link")
    LineBreak -> pretty_void_element("LineBreak")
    SoftBreak -> pretty_void_element("SoftBreak")
    Emph(content) ->
      [pretty_inlines(content)]
      |> pretty_element("Emph")
    Strong(content) ->
      [pretty_inlines(content)]
      |> pretty_element("Strong")
    Strikeout(content) ->
      [pretty_inlines(content)]
      |> pretty_element("Strikeout")
    Code(attrs, text) ->
      [pretty_attributes(attrs), glam.space, pretty_string(text)]
      |> pretty_element("Code")
    Span(attrs, content) ->
      [pretty_attributes(attrs), glam.space, pretty_inlines(content)]
      |> pretty_element("Span")
  }
}

fn pretty_attributes(attrs: Attributes) -> glam.Document {
  let pretty_classes = list.map(attrs.classes, pretty_string) |> pretty_list
  let pretty_keyvalues =
    list.map(attrs.keyvalues, pretty_keyvalue) |> pretty_list
  [pretty_string(attrs.id), pretty_classes, pretty_keyvalues]
  |> pretty_tuple
}

fn pretty_keyvalue(keyvalue: #(String, String)) -> glam.Document {
  [keyvalue.0, keyvalue.1] |> list.map(pretty_string) |> pretty_tuple
}

fn pretty_list_attributes(attrs: ListAttributes) -> glam.Document {
  let pretty_number_style = case attrs.style {
    Decimal -> glam.from_string("Decimal")
    LowerAlpha -> glam.from_string("LowerAlpha")
    UpperAlpha -> glam.from_string("UpperAlpha")
    LowerRoman -> glam.from_string("LowerRoman")
    UpperRoman -> glam.from_string("UpperRoman")
  }
  let pretty_delimiter = case attrs.delimiter {
    Period -> glam.from_string("Period")
    OneParen -> glam.from_string("OneParen")
    TwoParens -> glam.from_string("TwoParens")
  }
  [pretty_number(attrs.start), pretty_number_style, pretty_delimiter]
  |> pretty_tuple
}

fn pretty_link_target(target: Target) -> glam.Document {
  [pretty_string(target.url), pretty_string(target.title)] |> pretty_tuple
}

fn pretty_void_element(name: String) -> glam.Document {
  glam.from_string(name) |> glam.group
}

fn pretty_element(parts: List(glam.Document), name: String) -> glam.Document {
  let open_element = [glam.from_string(name), glam.space] |> glam.concat
  parts
  |> glam.concat
  |> glam.prepend(open_element)
  |> glam.nest(by: 2)
  |> glam.group
}

fn pretty_string(value: String) -> glam.Document {
  glam.from_string("\"" <> value <> "\"")
}

fn pretty_number(number: Int) -> glam.Document {
  glam.from_string(int.to_string(number))
}

fn pretty_list(docs: List(glam.Document)) -> glam.Document {
  pretty_sequence(docs, "[", "]")
}

fn pretty_tuple(docs: List(glam.Document)) -> glam.Document {
  pretty_sequence(docs, "(", ")")
}

fn pretty_sequence(
  docs: List(glam.Document),
  open: String,
  close: String,
) -> glam.Document {
  let comma = [glam.from_string(" ,"), glam.space] |> glam.concat
  let open_list = [glam.from_string(open), glam.space] |> glam.concat
  let trailing_comma = glam.break(" ", " ,")
  let close_list = [trailing_comma, glam.from_string(close)] |> glam.concat

  docs
  |> glam.join(with: comma)
  |> glam.prepend(open_list)
  |> glam.nest(by: 2)
  |> glam.append(close_list)
  |> glam.group
}
