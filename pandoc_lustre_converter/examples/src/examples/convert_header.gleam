import examples/pandoc
import lustre/element
import pandoc_lustre_converter as converter

pub fn main() {
  let header =
    "# Header"
    |> pandoc.parse("markdown")
    |> converter.convert_document
    |> element.to_readable_string
  assert header == "<h1 id=\"header\">\n  Header\n</h1>\n"
}
