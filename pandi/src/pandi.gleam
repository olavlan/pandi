import glam/doc as glam
import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}

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

pub type BlockFilter =
  fn(Block, Meta) -> Option(List(Block))

pub type InlineFilter =
  fn(Inline, Meta) -> Option(List(Inline))

pub fn filter_blocks(document: Document, filter: BlockFilter) -> Document {
  let new_blocks = walk_blocks(document.blocks, document.meta, filter)
  Document(..document, blocks: new_blocks)
}

pub fn filter_inlines(document: Document, filter: InlineFilter) -> Document {
  let new_blocks =
    list.map(document.blocks, walk_inlines_in_block(_, document.meta, filter))
  Document(..document, blocks: new_blocks)
}

fn walk_blocks(
  blocks: List(Block),
  meta: Meta,
  filter: BlockFilter,
) -> List(Block) {
  list.flat_map(blocks, fn(block) {
    case filter(block, meta) {
      Some(new_blocks) -> new_blocks
      None -> {
        case block {
          Div(attrs, content) -> [
            Div(attrs, walk_blocks(content, meta, filter)),
          ]
          BulletList(items) -> [
            BulletList(list.map(items, walk_blocks(_, meta, filter))),
          ]
          _ -> [block]
        }
      }
    }
  })
}

fn walk_inlines_in_block(
  block: Block,
  meta: Meta,
  filter: InlineFilter,
) -> Block {
  case block {
    Header(level, attrs, content) ->
      Header(level, attrs, walk_inlines(content, meta, filter))
    Para(content) -> Para(walk_inlines(content, meta, filter))
    Plain(content) -> Plain(walk_inlines(content, meta, filter))
    Div(attrs, content) ->
      Div(attrs, list.map(content, walk_inlines_in_block(_, meta, filter)))
    BulletList(items) ->
      BulletList(
        list.map(items, list.map(_, walk_inlines_in_block(_, meta, filter))),
      )
    _ -> block
  }
}

fn walk_inlines(
  inlines: List(Inline),
  meta: Meta,
  filter: InlineFilter,
) -> List(Inline) {
  list.flat_map(inlines, fn(inline) {
    case filter(inline, meta) {
      Some(new_inlines) -> new_inlines
      None -> {
        case inline {
          Emph(content) -> [
            Emph(walk_inlines(content, meta, filter)),
          ]
          Strong(content) -> [
            Strong(walk_inlines(content, meta, filter)),
          ]
          Strikeout(content) -> [
            Strikeout(walk_inlines(content, meta, filter)),
          ]
          Span(attrs, content) -> [
            Span(attrs, walk_inlines(content, meta, filter)),
          ]
          Link(attrs, content, target) -> [
            Link(attrs, walk_inlines(content, meta, filter), target),
          ]
          _ -> [inline]
        }
      }
    }
  })
}

pub fn to_readable_string(document: Document) -> String {
  pretty_blocks(document.blocks)
  |> glam.to_string(10)
}

fn pretty_blocks(blocks: List(Block)) -> glam.Document {
  list.map(blocks, pretty_block)
  |> pretty_list
}

fn pretty_inlines(inlines: List(Inline)) -> glam.Document {
  list.map(inlines, pretty_inline)
  |> pretty_list
}

fn pretty_list(list: List(glam.Document)) -> glam.Document {
  let comma = glam.concat([glam.from_string(" ,"), glam.space])
  let open_square = glam.concat([glam.from_string("["), glam.space])
  let trailing_comma = glam.break(" ", " ,")
  let close_square = glam.concat([trailing_comma, glam.from_string("]")])

  list
  |> glam.join(with: comma)
  |> glam.prepend(open_square)
  |> glam.nest(by: 2)
  |> glam.append(close_square)
  |> glam.group
}

fn pretty_block(block: Block) -> glam.Document {
  case block {
    Para(content) ->
      pretty_inlines(content)
      |> glam.prepend(open_element("Para"))
      |> glam.nest(by: 2)
      |> glam.group
    Header(level, attrs, content) ->
      glam.concat([
        glam.from_string("1"),
        glam.space,
        pretty_attributes(attrs),
        glam.space,
        pretty_inlines(content),
      ])
      |> glam.prepend(open_element("Header"))
      |> glam.nest(by: 2)
      |> glam.group
    _ -> glam.from_string("block")
  }
}

fn pretty_inline(inline: Inline) -> glam.Document {
  glam.from_string("inline")
}

fn pretty_attributes(attrs: Attributes) -> glam.Document {
  glam.from_string("(attributes)")
}

fn open_element(name: String) -> glam.Document {
  glam.concat([glam.from_string(name), glam.space])
}
