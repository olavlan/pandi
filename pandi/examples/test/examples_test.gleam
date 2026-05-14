import gleeunit
import gleeunit/should
import shellout

pub fn main() -> Nil {
  gleeunit.main()
}

fn run_pandoc_test(
  filter_path filter_path: String,
  markdown_input markdown_input: String,
  expected_html_output expected_html_output: String,
) {
  let assert Ok(html) =
    shellout.command(
      run: "sh",
      with: [
        "-c",
        "echo '"
          <> markdown_input
          <> "' | pandoc -f markdown -t json | gleam run --no-print-progress -m "
          <> filter_path
          <> " | pandoc -f json -t html",
      ],
      in: ".",
      opt: [],
    )

  html |> should.equal(expected_html_output)
}

pub fn increases_header_level_test() {
  run_pandoc_test(
    filter_path: "examples/increase_header_level",
    markdown_input: "# Header",
    expected_html_output: "<h2 id=\"header\">Header</h2>\n",
  )
}
