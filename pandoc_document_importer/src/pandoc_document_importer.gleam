import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import pandi/doc
import shellout
import simplifile

const document_folder = "./static/"

const json_file = "./static/static.json"

pub fn main() {
  let assert Ok(document_files) = simplifile.get_files(document_folder)
  document_files
  |> list.map(file_to_document)
  |> result.values
  |> json.object
  |> json.to_string
  |> simplifile.write(to: json_file, contents: _)
  let assert Ok(static) = import_static()
  static |> get_posts("articles") |> echo
}

pub type PandocError {
  CommandError
  DecodeError
}

pub fn get_posts(
  content: dict.Dict(String, doc.Document),
  folder_name: String,
) -> List(#(String, doc.Document)) {
  dict.to_list(content)
  |> list.filter(fn(item) { string.starts_with(item.0, folder_name <> "/") })
}

pub fn import_static() -> Result(dict.Dict(String, doc.Document), Nil) {
  let read_result =
    simplifile.read(json_file)
    |> result.map_error(fn(_) { Nil })
  use json_content <- result.try(read_result)
  let decoder = decode.dict(decode.string, doc.decoder())
  let decode_result =
    json.parse(from: json_content, using: decoder)
    |> result.map_error(fn(_) { Nil })
  use static <- result.try(decode_result)
  Ok(static)
}

fn file_to_document(
  from_file filename: String,
) -> Result(#(String, json.Json), PandocError) {
  let pandoc_result =
    shellout.command(
      run: "pandoc",
      with: ["-t", "json", filename],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
    |> result.map_error(fn(_) { CommandError })
  use json <- result.try(pandoc_result)
  let decode_result =
    doc.from_json(json) |> result.map_error(fn(_) { DecodeError })
  use document <- result.try(decode_result)
  let key = string.remove_prefix(filename, document_folder)
  Ok(#(key, doc.encode(document)))
}
