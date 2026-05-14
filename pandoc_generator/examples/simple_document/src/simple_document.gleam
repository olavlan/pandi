import gleam/io
import pandi
import pandoc_generator.{document_generator}
import qcheck

pub fn main() {
  let seed = qcheck.random_seed()
  let #(docs, _) = qcheck.generate(document_generator(), 1, seed)
  let assert [doc] = docs
  doc |> pandi.to_json |> io.println
}
