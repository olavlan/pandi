import gleam/json
import gleam/list
import pandi/pandoc as pd

pub fn encode_document(doc: pd.Document) -> json.Json {
  json.object([
    #("pandoc-api-version", json.array([1, 23, 1], json.int)),
    #("meta", encode_meta(doc.meta)),
    #("blocks", json.array(doc.blocks, encode_block)),
  ])
}

fn encode_meta(meta: pd.Meta) -> json.Json {
  meta
  |> list.map(fn(pair) { #(pair.0, encode_meta_value(pair.1)) })
  |> json.object
}

fn encode_meta_value(val: String) -> json.Json {
  json.object([
    #("t", json.string("pd.MetaInlines")),
    #("c", json.array([pd.Str(val)], encode_inline)),
  ])
}

fn encode_block(block: pd.Block) -> json.Json {
  case block {
    pd.Header(level, attributes, content) ->
      json.object([
        #("t", json.string("Header")),
        #("c", encode_header_content(level, attributes, content)),
      ])
    pd.Para(content) ->
      json.object([
        #("t", json.string("Para")),
        #("c", json.array(content, encode_inline)),
      ])
    pd.Plain(content) ->
      json.object([
        #("t", json.string("Plain")),
        #("c", json.array(content, encode_inline)),
      ])
    pd.CodeBlock(attributes, text) ->
      json.object([
        #("t", json.string("CodeBlock")),
        #("c", encode_code_block_content(attributes, text)),
      ])
    pd.Div(attributes, content) ->
      json.object([
        #("t", json.string("Div")),
        #("c", encode_div_content(attributes, content)),
      ])
    pd.BulletList(items) ->
      json.object([
        #("t", json.string("BulletList")),
        #("c", json.array(items, encode_bullet_list_item)),
      ])
    pd.OrderedList(attrs, items) ->
      json.object([
        #("t", json.string("OrderedList")),
        #("c", encode_ordered_list_content(attrs, items)),
      ])
    pd.BlockQuote(content) ->
      json.object([
        #("t", json.string("BlockQuote")),
        #("c", json.array(content, encode_block)),
      ])
  }
}

fn encode_inline(inline: pd.Inline) -> json.Json {
  case inline {
    pd.Str(content) ->
      json.object([
        #("t", json.string("Str")),
        #("c", json.string(content)),
      ])
    pd.Space ->
      json.object([
        #("t", json.string("Space")),
      ])
    pd.LineBreak ->
      json.object([
        #("t", json.string("LineBreak")),
      ])
    pd.SoftBreak ->
      json.object([
        #("t", json.string("SoftBreak")),
      ])
    pd.Emph(content) ->
      json.object([
        #("t", json.string("Emph")),
        #("c", json.array(content, encode_inline)),
      ])
    pd.Strong(content) ->
      json.object([
        #("t", json.string("Strong")),
        #("c", json.array(content, encode_inline)),
      ])
    pd.Strikeout(content) ->
      json.object([
        #("t", json.string("Strikeout")),
        #("c", json.array(content, encode_inline)),
      ])
    pd.Code(attributes, text) ->
      json.object([
        #("t", json.string("Code")),
        #("c", encode_code_content(attributes, text)),
      ])
    pd.Span(attributes, content) ->
      json.object([
        #("t", json.string("Span")),
        #("c", encode_span_content(attributes, content)),
      ])
    pd.Link(attributes, content, target) ->
      json.object([
        #("t", json.string("Link")),
        #("c", encode_link_content(attributes, content, target)),
      ])
  }
}

fn encode_code_content(attributes: pd.Attributes, text: String) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.string(text),
  ])
}

fn encode_div_content(
  attributes: pd.Attributes,
  content: List(pd.Block),
) -> json.Json {
  let encoded_attributes = encode_attributes(attributes)
  let encoded_content = json.array(content, encode_block)

  json.preprocessed_array([encoded_attributes, encoded_content])
}

fn encode_code_block_content(
  attributes: pd.Attributes,
  text: String,
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.string(text),
  ])
}

fn encode_span_content(
  attributes: pd.Attributes,
  content: List(pd.Inline),
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.array(content, encode_inline),
  ])
}

fn encode_link_content(
  attributes: pd.Attributes,
  content: List(pd.Inline),
  target: pd.Target,
) -> json.Json {
  json.preprocessed_array([
    encode_attributes(attributes),
    json.array(content, encode_inline),
    encode_target(target),
  ])
}

fn encode_target(target: pd.Target) -> json.Json {
  json.preprocessed_array([json.string(target.url), json.string(target.title)])
}

fn encode_header_content(
  level: Int,
  attributes: pd.Attributes,
  content: List(pd.Inline),
) -> json.Json {
  json.preprocessed_array([
    json.int(level),
    encode_attributes(attributes),
    json.array(content, encode_inline),
  ])
}

fn encode_attributes(attrs: pd.Attributes) -> json.Json {
  json.preprocessed_array([
    json.string(attrs.id),
    json.array(attrs.classes, json.string),
    json.array(attrs.keyvalues, encode_keyvalue),
  ])
}

fn encode_keyvalue(keyvalue: #(String, String)) -> json.Json {
  json.preprocessed_array([json.string(keyvalue.0), json.string(keyvalue.1)])
}

fn encode_bullet_list_item(item: List(pd.Block)) -> json.Json {
  json.array(item, encode_block)
}

fn encode_ordered_list_content(
  attrs: pd.ListAttributes,
  items: List(List(pd.Block)),
) -> json.Json {
  json.preprocessed_array([
    encode_list_attributes(attrs),
    json.array(items, encode_bullet_list_item),
  ])
}

fn encode_list_attributes(attrs: pd.ListAttributes) -> json.Json {
  json.preprocessed_array([
    json.int(attrs.start),
    encode_list_number_style(attrs.style),
    encode_list_number_delimiter(attrs.delimiter),
  ])
}

fn encode_list_number_style(style: pd.ListNumberStyle) -> json.Json {
  let t = case style {
    pd.Decimal -> "Decimal"
    pd.LowerAlpha -> "LowerAlpha"
    pd.UpperAlpha -> "UpperAlpha"
    pd.LowerRoman -> "LowerRoman"
    pd.UpperRoman -> "UpperRoman"
  }
  json.object([#("t", json.string(t))])
}

fn encode_list_number_delimiter(delim: pd.ListNumberDelimiter) -> json.Json {
  let t = case delim {
    pd.Period -> "Period"
    pd.OneParen -> "OneParen"
    pd.TwoParens -> "TwoParens"
  }
  json.object([#("t", json.string(t))])
}
