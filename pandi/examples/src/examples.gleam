import examples/complete_example
import examples/gleam_markdown
import examples/gleam_markdown_with_filter

pub fn main() {
  let _ = gleam_markdown.main()
  let _ = gleam_markdown_with_filter.main()
  complete_example.main()
}
