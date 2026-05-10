import pandi/generator/block.{block_generator}
import pandi/pandoc as pd
import qcheck

pub fn document_generator() -> qcheck.Generator(pd.Document) {
  qcheck.map(
    qcheck.generic_list(block_generator(), qcheck.bounded_int(5, 10)),
    fn(blocks) { pd.Document(blocks, []) },
  )
}
