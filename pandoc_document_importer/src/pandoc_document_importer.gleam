import gleam/io
import gleam/list
import gleam/result
import gleam/string
import pandi/doc
import shellout
import simplifile

const document_folder = "./static/"

pub fn main() {
  let assert Ok(document_files) = simplifile.get_files(document_folder)
  document_files
  |> list.map(file_to_document)
  |> result.values
  |> list.each(fn(entry) {
    io.println(entry.0)
    io.println(entry.1 |> doc.to_string())
  })
}

pub type PandocError {
  CommandError
  DecodeError
}

pub fn file_to_document(
  from_file filename: String,
) -> Result(#(String, doc.Document), PandocError) {
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
  Ok(#(key, document))
}
