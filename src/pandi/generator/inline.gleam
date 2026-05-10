import gleam/list
import pandi/generator/shared.{attributes_generator, tiny_string_generator}
import pandi/pandoc as pd
import qcheck

pub fn inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  separated_inlines_generator(inline_generator(), qcheck.bounded_int(1, 3))
}

fn separated_inlines_generator(
  content content: qcheck.Generator(pd.Inline),
  size size: qcheck.Generator(Int),
) -> qcheck.Generator(List(pd.Inline)) {
  qcheck.map2(
    qcheck.generic_list(content, size),
    qcheck.generic_list(separator_generator(), size),
    fn(contents, seps) {
      //needs simplification
      list.zip(contents, list.append(seps, [pd.Space]))
      |> list.flat_map(fn(pair) { [pair.0, pair.1] })
      |> list.drop(1)
    },
  )
}

fn separator_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(qcheck.return(pd.Space), [qcheck.return(pd.SoftBreak)])
}

fn inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(str_generator(), [
    line_break_generator(),
    code_inline_generator(),
    emph_generator(),
    strong_generator(),
    strikeout_generator(),
    span_generator(),
    link_generator(),
  ])
}

fn str_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(tiny_string_generator(), pd.Str)
}

fn line_break_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.return(pd.LineBreak)
}

fn code_inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map2(attributes_generator(), tiny_string_generator(), pd.Code)
}

fn emph_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), pd.Emph)
}

fn strong_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), pd.Strong)
}

fn strikeout_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map(leaf_inlines_generator(), pd.Strikeout)
}

fn span_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map2(attributes_generator(), leaf_inlines_generator(), pd.Span)
}

fn link_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.map3(
    attributes_generator(),
    leaf_inlines_generator(),
    target_generator(),
    pd.Link,
  )
}

fn target_generator() -> qcheck.Generator(pd.Target) {
  qcheck.map2(tiny_string_generator(), tiny_string_generator(), pd.Target)
}

fn leaf_inlines_generator() -> qcheck.Generator(List(pd.Inline)) {
  separated_inlines_generator(str_generator(), qcheck.bounded_int(1, 3))
}
