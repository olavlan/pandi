import gleeunit/should
import pandi as pd
import qcheck
import qcheck_pandoc.{document_generator}

pub fn encode_decode_roundtrip_test() {
  let config =
    qcheck.default_config()
    |> qcheck.with_test_count(10)
  qcheck.run(config, document_generator(), fn(doc) {
    let json = pd.to_json(doc)
    let decoded = pd.from_json(json)
    decoded |> should.equal(Ok(doc))
  })
}
