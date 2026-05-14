import gleam/list
import pandi as pd
import qcheck

pub fn document_generator() -> qcheck.Generator(pd.Document) {
  qcheck.map(
    qcheck.generic_list(block_generator(), qcheck.bounded_int(5, 10)),
    fn(blocks) { pd.Document(blocks, []) },
  )
}

pub fn block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    plain_generator(),
    header_generator(),
    code_block_generator(),
    div_generator(),
    bullet_list_generator(),
    ordered_list_generator(),
    block_quote_generator(),
  ])
}

fn plain_generator() -> qcheck.Generator(pd.Block) {
  use content <- qcheck.map(inlines_generator())
  pd.Plain(content)
}

fn para_generator() -> qcheck.Generator(pd.Block) {
  use content <- qcheck.map(inlines_generator())
  pd.Para(content)
}

fn header_generator() -> qcheck.Generator(pd.Block) {
  use level, attributes, content <- qcheck.map3(
    qcheck.bounded_int(1, 6),
    attributes_generator(),
    inlines_generator(),
  )
  pd.Header(level, attributes, content)
}

fn code_block_generator() -> qcheck.Generator(pd.Block) {
  use attributes, text <- qcheck.map2(attributes_generator(), word_generator())
  pd.CodeBlock(attributes, text)
}

fn div_generator() -> qcheck.Generator(pd.Block) {
  use attributes, content <- qcheck.map2(
    attributes_generator(),
    simple_blocks_generator(),
  )
  pd.Div(attributes, content)
}

fn bullet_list_generator() -> qcheck.Generator(pd.Block) {
  use items <- qcheck.map(qcheck.generic_list(
    simple_blocks_generator(),
    qcheck.bounded_int(2, 5),
  ))
  pd.BulletList(items)
}

fn ordered_list_generator() -> qcheck.Generator(pd.Block) {
  use attributes, items <- qcheck.map2(
    list_attributes_generator(),
    qcheck.generic_list(simple_blocks_generator(), qcheck.bounded_int(2, 5)),
  )
  pd.OrderedList(attributes, items)
}

fn block_quote_generator() -> qcheck.Generator(pd.Block) {
  use content <- qcheck.map(simple_blocks_generator())
  pd.BlockQuote(content)
}

fn simple_blocks_generator() -> qcheck.Generator(List(pd.Block)) {
  qcheck.generic_list(leaf_block_generator(), qcheck.bounded_int(1, 3))
}

fn leaf_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    plain_generator(),
    header_generator(),
    code_block_generator(),
  ])
}

fn list_attributes_generator() -> qcheck.Generator(pd.ListAttributes) {
  use start, style, delimiter <- qcheck.map3(
    qcheck.return(1),
    list_number_style_generator(),
    list_number_delimiter_generator(),
  )
  pd.ListAttributes(start, style, delimiter)
}

fn list_number_style_generator() -> qcheck.Generator(pd.ListNumberStyle) {
  qcheck.from_generators(qcheck.return(pd.Decimal), [
    qcheck.return(pd.LowerAlpha),
    qcheck.return(pd.UpperAlpha),
    qcheck.return(pd.LowerRoman),
    qcheck.return(pd.UpperRoman),
  ])
}

fn list_number_delimiter_generator() -> qcheck.Generator(pd.ListNumberDelimiter) {
  qcheck.from_generators(qcheck.return(pd.Period), [
    qcheck.return(pd.OneParen),
    qcheck.return(pd.TwoParens),
  ])
}

pub fn inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  use length <- qcheck.bind(qcheck.small_non_negative_int())
  use separators, segments <- qcheck.map2(
    qcheck.fixed_length_list_from(separator_generator(), length),
    qcheck.fixed_length_list_from(non_separator_generator(), length),
  )
  list.interleave([segments, separators])
}

fn separator_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(qcheck.return(pd.Space), [qcheck.return(pd.SoftBreak)])
}

fn non_separator_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_generator(),
    emph_generator(),
    strong_generator(),
    strikeout_generator(),
    span_generator(),
    link_generator(),
  ])
}

fn str_generator() -> qcheck.Generator(pd.Inline) {
  use word <- qcheck.map(word_generator())
  pd.Str(word)
}

fn line_break_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.return(pd.LineBreak)
}

fn code_generator() -> qcheck.Generator(pd.Inline) {
  use attributes, text <- qcheck.map2(attributes_generator(), word_generator())
  pd.Code(attributes, text)
}

fn emph_generator() -> qcheck.Generator(pd.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  pd.Emph(content)
}

fn strong_generator() -> qcheck.Generator(pd.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  pd.Strong(content)
}

fn strikeout_generator() -> qcheck.Generator(pd.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  pd.Strikeout(content)
}

fn span_generator() -> qcheck.Generator(pd.Inline) {
  use attributes, content <- qcheck.map2(
    attributes_generator(),
    simple_inlines_generator(),
  )
  pd.Span(attributes, content)
}

fn link_generator() -> qcheck.Generator(pd.Inline) {
  use attributes, content, target <- qcheck.map3(
    attributes_generator(),
    simple_inlines_generator(),
    target_generator(),
  )
  pd.Link(attributes, content, target)
}

fn target_generator() -> qcheck.Generator(pd.Target) {
  use title, url <- qcheck.map2(word_generator(), word_generator())
  pd.Target(title, url)
}

fn simple_inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  use length <- qcheck.bind(qcheck.small_non_negative_int())
  use separators, segments <- qcheck.map2(
    qcheck.fixed_length_list_from(separator_generator(), length),
    qcheck.fixed_length_list_from(leaf_inline_generator(), length),
  )
  list.interleave([segments, separators])
}

fn leaf_inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_generator(),
  ])
}

pub fn word_generator() -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.lowercase_ascii_codepoint(),
    qcheck.bounded_int(3, 5),
  )
}

pub fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  use identifier, classes, keyvalues <- qcheck.map3(
    qcheck.from_generators(word_generator(), [qcheck.return("")]),
    qcheck.generic_list(word_generator(), qcheck.bounded_int(0, 2)),
    qcheck.generic_list(keyvalue_generator(), qcheck.bounded_int(0, 1)),
  )
  pd.Attributes(identifier, classes, keyvalues)
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  use key, value <- qcheck.map2(word_generator(), word_generator())
  #(key, value)
}
