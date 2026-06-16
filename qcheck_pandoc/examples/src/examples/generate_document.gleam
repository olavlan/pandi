import pandi/doc
import qcheck
import qcheck_pandoc.{document_generator}

pub fn main() {
  let seed = qcheck.random_seed()
  let #(documents, _) = qcheck.generate(document_generator(), 1, seed)
  let assert [document] = documents
  document |> doc.to_string
}
