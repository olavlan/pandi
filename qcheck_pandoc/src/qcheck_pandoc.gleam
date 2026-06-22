import gleam/list
import pandi/doc
import qcheck

pub fn document_generator() -> qcheck.Generator(doc.Document) {
  qcheck.map(
    qcheck.generic_list(block_generator(), qcheck.bounded_int(5, 10)),
    fn(blocks) { doc.Document(blocks, []) },
  )
}

pub fn block_generator() -> qcheck.Generator(doc.Block) {
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

fn plain_generator() -> qcheck.Generator(doc.Block) {
  use content <- qcheck.map(inlines_generator())
  doc.Plain(content)
}

fn para_generator() -> qcheck.Generator(doc.Block) {
  use content <- qcheck.map(inlines_generator())
  doc.Para(content)
}

fn header_generator() -> qcheck.Generator(doc.Block) {
  use level, attributes, content <- qcheck.map3(
    qcheck.bounded_int(1, 6),
    attributes_generator(),
    inlines_generator(),
  )
  doc.Header(level, attributes, content)
}

fn code_block_generator() -> qcheck.Generator(doc.Block) {
  use attributes, text <- qcheck.map2(attributes_generator(), word_generator())
  doc.CodeBlock(attributes, text)
}

fn div_generator() -> qcheck.Generator(doc.Block) {
  use attributes, content <- qcheck.map2(
    attributes_generator(),
    simple_blocks_generator(),
  )
  doc.Div(attributes, content)
}

fn bullet_list_generator() -> qcheck.Generator(doc.Block) {
  use items <- qcheck.map(qcheck.generic_list(
    simple_blocks_generator(),
    qcheck.bounded_int(2, 5),
  ))
  doc.BulletList(items)
}

fn ordered_list_generator() -> qcheck.Generator(doc.Block) {
  use attributes, items <- qcheck.map2(
    list_attributes_generator(),
    qcheck.generic_list(simple_blocks_generator(), qcheck.bounded_int(2, 5)),
  )
  doc.OrderedList(attributes, items)
}

fn block_quote_generator() -> qcheck.Generator(doc.Block) {
  use content <- qcheck.map(simple_blocks_generator())
  doc.BlockQuote(content)
}

fn simple_blocks_generator() -> qcheck.Generator(List(doc.Block)) {
  qcheck.generic_list(leaf_block_generator(), qcheck.bounded_int(1, 3))
}

fn leaf_block_generator() -> qcheck.Generator(doc.Block) {
  qcheck.from_generators(para_generator(), [
    plain_generator(),
    header_generator(),
    code_block_generator(),
  ])
}

fn list_attributes_generator() -> qcheck.Generator(doc.ListAttributes) {
  use start, style, delimiter <- qcheck.map3(
    qcheck.return(1),
    list_number_style_generator(),
    list_number_delimiter_generator(),
  )
  doc.ListAttributes(start, style, delimiter)
}

fn list_number_style_generator() -> qcheck.Generator(doc.ListNumberStyle) {
  qcheck.from_generators(qcheck.return(doc.Decimal), [
    qcheck.return(doc.LowerAlpha),
    qcheck.return(doc.UpperAlpha),
    qcheck.return(doc.LowerRoman),
    qcheck.return(doc.UpperRoman),
  ])
}

fn list_number_delimiter_generator() -> qcheck.Generator(
  doc.ListNumberDelimiter,
) {
  qcheck.from_generators(qcheck.return(doc.Period), [
    qcheck.return(doc.OneParen),
    qcheck.return(doc.TwoParens),
  ])
}

pub fn inlines_generator() -> qcheck.Generator(List(doc.Inline)) {
  use length <- qcheck.bind(qcheck.small_non_negative_int())
  use separators, segments <- qcheck.map2(
    qcheck.fixed_length_list_from(separator_generator(), length),
    qcheck.fixed_length_list_from(non_separator_generator(), length),
  )
  list.interleave([segments, separators])
}

fn separator_generator() -> qcheck.Generator(doc.Inline) {
  qcheck.from_generators(qcheck.return(doc.Space), [
    qcheck.return(doc.SoftBreak),
  ])
}

fn non_separator_generator() -> qcheck.Generator(doc.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_generator(),
    math_generator(),
    emph_generator(),
    strong_generator(),
    strikeout_generator(),
    span_generator(),
    link_generator(),
  ])
}

fn str_generator() -> qcheck.Generator(doc.Inline) {
  use word <- qcheck.map(word_generator())
  doc.Str(word)
}

fn line_break_generator() -> qcheck.Generator(doc.Inline) {
  qcheck.return(doc.LineBreak)
}

fn code_generator() -> qcheck.Generator(doc.Inline) {
  use attributes, text <- qcheck.map2(attributes_generator(), word_generator())
  doc.Code(attributes, text)
}

fn math_generator() -> qcheck.Generator(doc.Inline) {
  use math_type, text <- qcheck.map2(math_type_generator(), word_generator())
  doc.Math(math_type, text)
}

fn math_type_generator() -> qcheck.Generator(doc.MathType) {
  qcheck.from_generators(qcheck.return(doc.InlineMath), [
    qcheck.return(doc.DisplayMath),
  ])
}

fn emph_generator() -> qcheck.Generator(doc.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  doc.Emph(content)
}

fn strong_generator() -> qcheck.Generator(doc.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  doc.Strong(content)
}

fn strikeout_generator() -> qcheck.Generator(doc.Inline) {
  use content <- qcheck.map(simple_inlines_generator())
  doc.Strikeout(content)
}

fn span_generator() -> qcheck.Generator(doc.Inline) {
  use attributes, content <- qcheck.map2(
    attributes_generator(),
    simple_inlines_generator(),
  )
  doc.Span(attributes, content)
}

fn link_generator() -> qcheck.Generator(doc.Inline) {
  use attributes, content, target <- qcheck.map3(
    attributes_generator(),
    simple_inlines_generator(),
    target_generator(),
  )
  doc.Link(attributes, content, target)
}

fn target_generator() -> qcheck.Generator(doc.Target) {
  use title, url <- qcheck.map2(word_generator(), word_generator())
  doc.Target(title, url)
}

fn simple_inlines_generator() -> qcheck.Generator(List(doc.Inline)) {
  use length <- qcheck.bind(qcheck.small_non_negative_int())
  use separators, segments <- qcheck.map2(
    qcheck.fixed_length_list_from(separator_generator(), length),
    qcheck.fixed_length_list_from(leaf_inline_generator(), length),
  )
  list.interleave([segments, separators])
}

fn leaf_inline_generator() -> qcheck.Generator(doc.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_generator(),
    math_generator(),
  ])
}

pub fn word_generator() -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.lowercase_ascii_codepoint(),
    qcheck.bounded_int(3, 5),
  )
}

pub fn attributes_generator() -> qcheck.Generator(doc.Attributes) {
  use identifier, classes, keyvalues <- qcheck.map3(
    qcheck.from_generators(word_generator(), [qcheck.return("")]),
    qcheck.generic_list(word_generator(), qcheck.bounded_int(0, 2)),
    qcheck.generic_list(keyvalue_generator(), qcheck.bounded_int(0, 1)),
  )
  doc.Attributes(identifier, classes, keyvalues)
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  use key, value <- qcheck.map2(word_generator(), word_generator())
  #(key, value)
}
