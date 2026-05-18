import examples/pandoc
import lustre/element
import pandoc_lustre_converter as pandoc_lustre

pub fn main() {
  let header =
    "# Header"
    |> pandoc.parse("markdown")
    |> pandoc_lustre.convert
    |> element.to_readable_string
  assert header == "<h1 id=\"header\">\n  Header\n</h1>\n"
}
