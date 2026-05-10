import pandi/pandoc as pd
import qcheck

pub fn tiny_string_generator() -> qcheck.Generator(String) {
  qcheck.generic_string(
    qcheck.lowercase_ascii_codepoint(),
    qcheck.bounded_int(1, 3),
  )
}

pub fn attributes_generator() -> qcheck.Generator(pd.Attributes) {
  qcheck.map3(
    tiny_string_generator(),
    qcheck.generic_list(tiny_string_generator(), qcheck.bounded_int(0, 1)),
    qcheck.generic_list(keyvalue_generator(), qcheck.bounded_int(0, 1)),
    pd.Attributes,
  )
}

fn keyvalue_generator() -> qcheck.Generator(#(String, String)) {
  qcheck.map2(tiny_string_generator(), tiny_string_generator(), fn(key, value) {
    #(key, value)
  })
}
