import gleeunit/should
import pandi
import pandi/pandoc as pd
import qcheck
import qcheck_gleeunit_utils/run

pub fn main() {
  run.run_gleeunit()
}

fn simple_string() -> qcheck.Generator(String) {
  qcheck.string_from(qcheck.alphanumeric_ascii_codepoint())
}

fn inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(qcheck.map(simple_string(), pd.Str), [
    qcheck.constant(pd.Space),
    qcheck.map2(attributes_generator(), simple_string(), pd.Code),
  ])
}

fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  qcheck.map(simple_string(), fn(id) { pd.Attributes(id, [], []) })
}

fn header_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map3(
    qcheck.uniform_int(),
    attributes_generator(),
    qcheck.list_from(inline_generator()),
    pd.Header,
  )
}

fn para_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map(qcheck.list_from(inline_generator()), pd.Para)
}

fn code_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(attributes_generator(), qcheck.string(), pd.CodeBlock)
}

fn list_number_style_generator() -> qcheck.Generator(pd.ListNumberStyle) {
  qcheck.from_generators(
    qcheck.constant(pd.Decimal),
    [
      qcheck.constant(pd.LowerAlpha),
      qcheck.constant(pd.UpperAlpha),
      qcheck.constant(pd.LowerRoman),
      qcheck.constant(pd.UpperRoman),
    ],
  )
}

fn list_number_delimiter_generator() -> qcheck.Generator(pd.ListNumberDelimiter) {
  qcheck.from_generators(
    qcheck.constant(pd.Period),
    [
      qcheck.constant(pd.OneParen),
      qcheck.constant(pd.TwoParens),
    ],
  )
}

fn list_attributes_generator() -> qcheck.Generator(pd.ListAttributes) {
  qcheck.map3(
    qcheck.uniform_int(),
    list_number_style_generator(),
    list_number_delimiter_generator(),
    pd.ListAttributes,
  )
}

fn ordered_list_generator() -> qcheck.Generator(pd.Block) {
  qcheck.map2(
    list_attributes_generator(),
    qcheck.list_from(qcheck.list_from(simple_block_generator())),
    pd.OrderedList,
  )
}

fn simple_block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    header_generator(),
    code_block_generator(),
  ])
}

fn block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    header_generator(),
    code_block_generator(),
    ordered_list_generator(),
  ])
}

fn document_generator() -> qcheck.Generator(pd.Document) {
  qcheck.map(qcheck.list_from(block_generator()), fn(blocks) {
    pd.Document(blocks, [])
  })
}

pub fn document_roundtrip_test() {
  let config = qcheck.default_config() |> qcheck.with_test_count(10)

  use doc <- qcheck.run(config, document_generator())

  let result =
    doc
    |> pandi.to_json
    |> pandi.from_json

  result |> should.equal(Ok(doc))
}
