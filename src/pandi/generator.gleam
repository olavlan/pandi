import gleam/list
import pandi/pandoc as pd
import qcheck

pub fn document_generator() -> qcheck.Generator(pd.Document) {
  qcheck.map(blocks_generator(), fn(blocks) { pd.Document(blocks, []) })
}

fn blocks_generator() -> qcheck.Generator(List(pd.Block)) {
  qcheck.generic_list(block_generator(), qcheck.bounded_int(5, 10))
}

fn leaf_blocks_generator() -> qcheck.Generator(List(pd.Block)) {
  qcheck.generic_list(leaf_block_generator(), qcheck.bounded_int(1, 3))
}

fn inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  qcheck.map2(
    qcheck.generic_list(inline_segment_generator(), qcheck.bounded_int(1, 3)),
    inline_generator(),
    fn(segments, last) { list.append(list.flatten(segments), [last]) },
  )
}

fn inline_segment_generator() -> qcheck.Generator(List(pd.Inline)) {
  qcheck.map2(
    inline_generator(),
    qcheck.from_generators(space_generator(), [soft_break_generator()]),
    fn(segment, sep) { [segment, sep] },
  )
}

fn leaf_inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  qcheck.map2(
    qcheck.generic_list(word_generator(), qcheck.bounded_int(1, 3)),
    str_generator(),
    fn(words, last) { list.append(list.flatten(words), [last]) },
  )
}

fn word_generator() -> qcheck.Generator(List(pd.Inline)) {
  qcheck.map2(
    str_generator(),
    qcheck.from_generators(space_generator(), [soft_break_generator()]),
    fn(word, sep) { [word, sep] },
  )
}

fn soft_break_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.return(pd.SoftBreak)
}

fn block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    plain_generator(),
    header_generator(),
    code_block_generator(),
    div_generator(),
    bullet_list_generator(),
    ordered_list_generator(),
  ])
}

fn leaf_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    plain_generator(),
    header_generator(),
    code_block_generator(),
  ])
}

fn inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(str_generator(), [
    space_generator(),
    line_break_generator(),
    emph_generator(),
    strong_generator(),
    strikeout_generator(),
    code_inline_generator(),
    span_generator(),
    link_generator(),
  ])
}

fn tiny_string() -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.lowercase_ascii_codepoint(),
    qcheck.bounded_int(1, 3),
  )
}

fn para_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(inlines_generator(), fn(content) { pd.Para(content) })
}

fn plain_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(inlines_generator(), fn(content) { pd.Plain(content) })
}

fn header_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map3(
    qcheck.bounded_int(1, 6),
    attributes_generator(),
    inlines_generator(),
    fn(level, attrs, content) { pd.Header(level, attrs, content) },
  )
}

fn code_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(
    attributes_generator(),
    tiny_string(),
    fn(attrs, text) { pd.CodeBlock(attrs, text) },
  )
}

fn div_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(
    attributes_generator(),
    leaf_blocks_generator(),
    fn(attrs, content) { pd.Div(attrs, content) },
  )
}

fn bullet_list_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(
    qcheck.generic_list(leaf_blocks_generator(), qcheck.bounded_int(2, 5)),
    fn(items) { pd.BulletList(items) },
  )
}

fn ordered_list_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(
    list_attributes_generator(),
    qcheck.generic_list(leaf_blocks_generator(), qcheck.bounded_int(2, 5)),
    fn(attrs, items) { pd.OrderedList(attrs, items) },
  )
}

fn str_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(tiny_string(), fn(content) { pd.Str(content) })
}

fn space_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.return(pd.Space)
}

fn line_break_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.return(pd.LineBreak)
}

fn emph_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), fn(content) { pd.Emph(content) })
}

fn strong_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), fn(content) { pd.Strong(content) })
}

fn strikeout_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), fn(content) { pd.Strikeout(content) })
}

fn code_inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map2(
    attributes_generator(),
    tiny_string(),
    fn(attrs, text) { pd.Code(attrs, text) },
  )
}

fn span_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map2(
    attributes_generator(),
    leaf_inlines_generator(),
    fn(attrs, content) { pd.Span(attrs, content) },
  )
}

fn link_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map3(
    attributes_generator(),
    leaf_inlines_generator(),
    target_generator(),
    fn(attrs, content, target) { pd.Link(attrs, content, target) },
  )
}

fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  qcheck.map3(
    tiny_string(),
    qcheck.generic_list(tiny_string(), qcheck.bounded_int(0, 1)),
    qcheck.generic_list(keyvalue_generator(), qcheck.bounded_int(0, 1)),
    fn(id, classes, keyvalues) { pd.Attributes(id, classes, keyvalues) },
  )
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  qcheck.map2(tiny_string(), tiny_string(), fn(key, value) { #(key, value) })
}

fn target_generator() -> qcheck.Generator(pd.Target) {
  qcheck.map2(tiny_string(), tiny_string(), fn(url, title) {
    pd.Target(url, title)
  })
}

fn list_attributes_generator() -> qcheck.Generator(pd.ListAttributes) {
  qcheck.map3(
    qcheck.bounded_int(1, 3),
    list_number_style_generator(),
    list_number_delimiter_generator(),
    fn(start, style, delim) { pd.ListAttributes(start, style, delim) },
  )
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