import examples/complete_example
import examples/gleam_markdown_example
import examples/gleam_markdown_example_with_filter
import examples/to_string

pub fn main() {
  let _ = gleam_markdown_example.main()
  let _ = gleam_markdown_example_with_filter.main()
  let _ = complete_example.main()
  to_string.main()
}
