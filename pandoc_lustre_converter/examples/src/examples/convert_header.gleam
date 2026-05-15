import examples/pandoc.{parse}
import lustre/element.{to_readable_string}
import pandoc_lustre_converter.{convert_document}

pub fn main() {
  let header =
    "# Header"
    |> parse("markdown")
    |> convert_document
    |> to_readable_string
  assert header == "<h2 id=\"header\">\n  Header\n</h1>\n"
}
