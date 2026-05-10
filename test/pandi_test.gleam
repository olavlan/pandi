import gleeunit/should
import pandi
import pandi/pandoc as pd
import qcheck
import qcheck_gleeunit_utils/run

pub fn main() {
  run.run_gleeunit()
}

fn inline_generator() -> qcheck.Generator(pd.Inline) {
  qcheck.from_generators(qcheck.map(qcheck.string(), pd.Str), [
    qcheck.constant(pd.Space),
  ])
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  qcheck.tuple2(qcheck.string(), qcheck.string())
}

fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  qcheck.map3(
    qcheck.string(),
    qcheck.list_from(qcheck.string()),
    qcheck.list_from(keyvalue_generator()),
    pd.Attributes,
  )
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
