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

fn block_generator() -> qcheck.Generator(pd.Block) {
  qcheck.from_generators(para_generator(), [
    header_generator(),
    code_block_generator(),
  ])
}

fn document_generator() -> qcheck.Generator(pd.Document) {
  qcheck.map(qcheck.list_from(block_generator()), fn(blocks) {
    pd.Document(blocks, [])
  })
}

pub fn document_roundtrip_test() {
  let config = qcheck.default_config() |> qcheck.with_test_count(20)

  use doc <- qcheck.run(config, document_generator())

  let result =
    doc
    |> pandi.to_json
    |> pandi.from_json

  result |> should.equal(Ok(doc))
}
