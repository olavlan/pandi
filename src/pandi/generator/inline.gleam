import gleam/list
import pandi/generator/shared.{attributes_generator, word_generator}
import pandi/pandoc as pd
import qcheck

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
  use content <- qcheck.map(leafs_generator())
  pd.Emph(content)
}

fn strong_generator() -> qcheck.Generator(pd.Inline) {
  use content <- qcheck.map(leafs_generator())
  pd.Strong(content)
}

fn strikeout_generator() -> qcheck.Generator(pd.Inline) {
  use content <- qcheck.map(leafs_generator())
  pd.Strikeout(content)
}

fn span_generator() -> qcheck.Generator(pd.Inline) {
  use attributes, content <- qcheck.map2(
    attributes_generator(),
    leafs_generator(),
  )
  pd.Span(attributes, content)
}

fn link_generator() -> qcheck.Generator(pd.Inline) {
  use attributes, content, target <- qcheck.map3(
    attributes_generator(),
    leafs_generator(),
    target_generator(),
  )
  pd.Link(attributes, content, target)
}

fn target_generator() -> qcheck.Generator(pd.Target) {
  use title, url <- qcheck.map2(word_generator(), word_generator())
  pd.Target(title, url)
}

fn leafs_generator() -> qcheck.Generator(List(pd.Inline)) {
  use length <- qcheck.bind(qcheck.small_non_negative_int())
  use separators, segments <- qcheck.map2(
    qcheck.fixed_length_list_from(separator_generator(), length),
    qcheck.fixed_length_list_from(leaf_generator(), length),
  )
  list.interleave([segments, separators])
}

fn leaf_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_generator(),
  ])
}
