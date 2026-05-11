import pandi/pandoc as pd
import qcheck

pub fn word_generator() -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.lowercase_ascii_codepoint(),
    qcheck.bounded_int(3, 5),
  )
}

pub fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  use identifier, classes, keyvalues <- qcheck.map3(
    qcheck.from_generators(word_generator(), [qcheck.return("")]),
    qcheck.generic_list(word_generator(), qcheck.bounded_int(0, 2)),
    qcheck.generic_list(keyvalue_generator(), qcheck.bounded_int(0, 1)),
  )
  pd.Attributes(identifier, classes, keyvalues)
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  use key, value <- qcheck.map2(word_generator(), word_generator())
  #(key, value)
}
