import examples/complete_example
import examples/gleam_markdown_example
import examples/gleam_markdown_example_with_filter

pub fn main() {
  let _ = gleam_markdown_example.main()
  let _ = gleam_markdown_example_with_filter.main()
  complete_example.main()
}
