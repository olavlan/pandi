import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

const monorepo_folder = ".."

pub type File {
  File(path: String, content: String)
}

fn read(path: String) -> File {
  let assert Ok(content) = simplifile.read(path)
  File(path, string.trim(content))
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
    "./" <> reference -> {
      let parsed = parse_reference(reference)
      let code = case parsed.marker {
        option.None -> read(parsed.path).content
        option.Some(marker) -> extract_segment(parsed.path, marker)
      }
      let extension =
        string.split(parsed.path, on: ".")
        |> list.last
        |> result.unwrap(or: "")
      case extension {
        "html" -> code
        _ -> "````" <> extension <> "\n" <> code <> "\n````"
      }
    }
    _ -> content
  }
}

type Reference {
  Reference(path: String, marker: option.Option(String))
}

fn parse_reference(reference: String) -> Reference {
  case string.split(reference, on: ":") {
    [relative_path] -> get_full_path(relative_path) |> Reference(option.None)
    [relative_path, marker] ->
      get_full_path(relative_path) |> Reference(option.Some(marker))
    _ -> panic as "could not parse reference"
  }
}

fn get_full_path(relative_path: String) {
  monorepo_folder <> "/" <> relative_path
}

fn extract_segment(path: String, marker: String) -> String {
  read(path).content
  |> string.split("//" <> marker <> "\n")
  |> take_every_other
  |> list.map(string.trim)
  |> list.first
  |> result.unwrap(or: "")
}

pub fn take_every_other(list: List(a)) -> List(a) {
  case list {
    [] | [_] -> []
    [_, second, ..rest] -> [second, ..take_every_other(rest)]
  }
}
