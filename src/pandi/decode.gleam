import gleam/dict
import gleam/dynamic/decode
import pandi/pandoc as pd

pub fn document_decoder() -> decode.Decoder(pd.Document) {
  use blocks <- decode.field("blocks", decode.list(block_decoder()))
  use meta <- decode.field("meta", meta_decoder())
  decode.success(pd.Document(blocks, meta))
}

fn meta_decoder() -> decode.Decoder(pd.Meta) {
  decode.dict(decode.string, meta_value_decoder())
  |> decode.map(dict.to_list)
}

fn meta_value_decoder() -> decode.Decoder(String) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  case content {
    [pd.Str(val)] -> decode.success(val)
    _ -> decode.failure("", "pd.MetaInlines")
  }
}

fn block_decoder() -> decode.Decoder(pd.Block) {
  use t <- decode.field("t", decode.string)
  case t {
    "Header" -> header_decoder()
    "Para" -> para_decoder()
    "Plain" -> plain_decoder()
    "CodeBlock" -> code_block_decoder()
    "Div" -> div_decoder()
    "BulletList" -> bullet_list_decoder()
    _ -> decode.failure(pd.Para([]), "Block")
  }
}

fn header_decoder() -> decode.Decoder(pd.Block) {
  use level <- decode_c_at(0, decode.int)
  use attributes <- decode_c_at(1, attributes_decoder())
  use content <- decode_c_at(2, decode.list(inline_decoder()))
  decode.success(pd.Header(level, attributes, content))
}

fn para_decoder() -> decode.Decoder(pd.Block) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  decode.success(pd.Para(content))
}

fn plain_decoder() -> decode.Decoder(pd.Block) {
  use content <- decode.field("c", decode.list(inline_decoder()))
  decode.success(pd.Plain(content))
}

fn code_block_decoder() -> decode.Decoder(pd.Block) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use text <- decode_c_at(1, decode.string)
  decode.success(pd.CodeBlock(attributes, text))
}

fn div_decoder() -> decode.Decoder(pd.Block) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(block_decoder)))
  decode.success(pd.Div(attributes, content))
}

fn bullet_list_decoder() -> decode.Decoder(pd.Block) {
  use items <- decode.field(
    "c",
    decode.list(decode.list(decode.recursive(block_decoder))),
  )
  decode.success(pd.BulletList(items))
}

fn inline_decoder() -> decode.Decoder(pd.Inline) {
  use t <- decode.field("t", decode.string)
  case t {
    "Str" -> str_decoder()
    "Space" -> space_decoder()
    "Span" -> span_decoder()
    "Link" -> link_decoder()
    _ -> decode.failure(pd.Space, "Inline")
  }
}

fn link_decoder() -> decode.Decoder(pd.Inline) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(inline_decoder)))
  use target <- decode_c_at(2, target_decoder())
  decode.success(pd.Link(attributes, content, target))
}

fn target_decoder() -> decode.Decoder(pd.Target) {
  use url <- decode.field(0, decode.string)
  use title <- decode.field(1, decode.string)
  decode.success(pd.Target(url, title))
}

fn span_decoder() -> decode.Decoder(pd.Inline) {
  use attributes <- decode_c_at(0, attributes_decoder())
  use content <- decode_c_at(1, decode.list(decode.recursive(inline_decoder)))
  decode.success(pd.Span(attributes, content))
}

fn str_decoder() -> decode.Decoder(pd.Inline) {
  use content <- decode.field("c", decode.string)
  decode.success(pd.Str(content))
}

fn space_decoder() -> decode.Decoder(pd.Inline) {
  decode.success(pd.Space)
}

fn attributes_decoder() -> decode.Decoder(pd.Attributes) {
  use id <- decode.field(0, decode.string)
  use classes <- decode.field(1, decode.list(decode.string))
  use keyvalues <- decode.field(2, decode.list(keyvalue_decoder()))
  decode.success(pd.Attributes(id, classes, keyvalues))
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
