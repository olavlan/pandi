import pandi/generator/inline.{inlines_generator}
import pandi/generator/shared.{attributes_generator, tiny_string_generator}
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
  ])
}

fn plain_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(inlines_generator(), pd.Plain)
}

fn para_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(inlines_generator(), pd.Para)
}

fn header_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map3(
    qcheck.bounded_int(1, 6),
    attributes_generator(),
    inlines_generator(),
    pd.Header,
  )
}

fn code_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(attributes_generator(), tiny_string_generator(), pd.CodeBlock)
}

fn div_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(attributes_generator(), leaf_blocks_generator(), pd.Div)
}

fn bullet_list_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(
    qcheck.generic_list(leaf_blocks_generator(), qcheck.bounded_int(2, 5)),
    pd.BulletList,
  )
}

fn ordered_list_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(
    list_attributes_generator(),
    qcheck.generic_list(leaf_blocks_generator(), qcheck.bounded_int(2, 5)),
    pd.OrderedList,
  )
}

fn leaf_blocks_generator() -> qcheck.Generator(List(pd.Block)) {
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
  qcheck.map3(
    qcheck.bounded_int(1, 3),
    list_number_style_generator(),
    list_number_delimiter_generator(),
    pd.ListAttributes,
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
