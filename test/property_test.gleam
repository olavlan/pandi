import gleeunit/should
import pandi
import pandi/generator
import qcheck

pub fn encode_decode_roundtrip_test() {
  let config =
    qcheck.default_config()
    |> qcheck.with_test_count(10)
  qcheck.run(config, generator.document_generator(), fn(doc) {
    let json = pandi.to_json(doc)
    let decoded = pandi.from_json(json)
    decoded |> should.equal(Ok(doc))
  })
}
