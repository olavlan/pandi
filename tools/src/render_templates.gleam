import gleam/list
import gleam/result
import gleam/string
import simplifile

const monorepo_folder = ".."

pub type File {
  File(path: String, content: String)
}

fn read(path: String) -> File {
  let assert Ok(content) = simplifile.read(path)
  File(path, content)
}

fn write(file: File) {
  simplifile.write(file.path, file.content)
}

pub fn main() {
  let assert Ok(files) = simplifile.get_files(in: monorepo_folder)
  list.filter(files, string.ends_with(_, ".template.md"))
  |> list.map(read)
  |> list.map(render_template)
  |> list.each(write)
}

pub fn render_template(file: File) -> File {
  let new_path = string.replace(file.path, ".template", "")
  let new_content =
    string.split(file.content, "\n")
    |> list.map(render_line)
    |> string.join(with: "\n")
  File(new_path, new_content)
}

pub fn render_line(content: String) -> String {
  case content {
    "//" <> code_reference ->
      "````gleam\n" <> render_code_segment(code_reference) <> "\n````"
    _ -> content
  }
}

pub fn render_code_segment(code_reference: String) -> String {
  case string.split(code_reference, on: ":") {
    [path] -> simplifile.read(from: path) |> result.unwrap(or: "")
    [path, pattern] ->
      simplifile.read(from: path)
      |> result.map(extract_code_segment(_, pattern))
      |> result.unwrap(or: "")
    _ -> ""
  }
}

/// Extracts a code segment enclosed by a comment marker:
///
/// ```gleam
/// let code = "//pi\n" <> "const pi = 3.14\n" <> "//pi\n" <> "const other = 42\n"
/// extract_code_segment(code, "pi")
/// // Ok("const pi = 3.14")
/// ```
///
/// If pattern doesn't exist, an empty string is returned.
pub fn extract_code_segment(code: String, marker: String) -> String {
  code
  |> string.split("//" <> marker <> "\n")
  |> take_every_other
  |> list.map(string.trim)
  |> list.first
  |> result.unwrap(or: "")
}

/// Take the elements with even index
pub fn take_every_other(list: List(a)) -> List(a) {
  case list {
    [] | [_] -> []
    [_, second, ..rest] -> [second, ..take_every_other(rest)]
  }
}
