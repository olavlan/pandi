import examples/block_filter_example
import examples/complete_example
import examples/filter_examples
import examples/gleam_markdown_example
import examples/gleam_markdown_example_with_filter
import examples/inline_filter_example
import examples/to_string

pub fn main() {
  complete_example.main()
  to_string.main()
  inline_filter_example.main()
  block_filter_example.main()
  filter_examples.main()
  gleam_markdown_example.main()
  gleam_markdown_example_with_filter.main()
}
