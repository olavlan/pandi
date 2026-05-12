import pandi/generator/inline.{inlines_generator}
import pandi/generator/shared.{attributes_generator, word_generator}
import pandi/pandoc as pd
import qcheck

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
    leafs_generator(),
  )
  pd.Div(attributes, content)
}

fn bullet_list_generator() -> qcheck.Generator(pd.Block) {
  use items <- qcheck.map(qcheck.generic_list(
    leafs_generator(),
    qcheck.bounded_int(2, 5),
  ))
  pd.BulletList(items)
}

fn ordered_list_generator() -> qcheck.Generator(pd.Block) {
  use attributes, items <- qcheck.map2(
    list_attributes_generator(),
    qcheck.generic_list(leafs_generator(), qcheck.bounded_int(2, 5)),
  )
  pd.OrderedList(attributes, items)
}

fn block_quote_generator() -> qcheck.Generator(pd.Block) {
  use content <- qcheck.map(leafs_generator())
  pd.BlockQuote(content)
}

fn leafs_generator() -> qcheck.Generator(List(pd.Block)) {
  qcheck.generic_list(leaf_generator(), qcheck.bounded_int(1, 3))
}

fn leaf_generator() -> qcheck.Generator(pd.Block) {
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
