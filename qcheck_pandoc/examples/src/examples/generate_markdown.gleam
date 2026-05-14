import examples/pandoc.{parse, render}
import gleam/io
import qcheck
import qcheck_pandoc.{document_generator}

pub fn main() {
  let seed = qcheck.random_seed()
  let #(docs, _) = qcheck.generate(document_generator(), 1, seed)
  let assert [doc] = docs
  doc |> pandi.to_json |> render("markdown") |> io.println
}

fn markdown_processor() {
  todo
}
