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
  |> list.map(string.split_once(_, on: document_folder))
  |> result.values
  |> list.map(fn(tuple) { tuple.1 })
  |> echo
  document_files
  |> list.map(string.remove_prefix(_, document_folder)
  |> list.map(fn(filename) {#(filename, file_to_document(filename) )}
  |> result.values
  |> list.each(io.println)
}

pub fn file_to_key_document(filename: String) -> #(String, Document) {
  let key = string.remove_prefix(filename, document_folder)
}

pub type PandocError {
  CommandError
  DecodeError
}

pub fn file_to_document(
  from_file filename: String,
) -> Result(doc.Document, PandocError) {
  let result =
    shellout.command(
      run: "pandoc",
      with: ["-t", "json", filename],
      in: document_folder,
      opt: [shellout.LetBeStderr],
    )
    |> result.map_error(fn(_) { CommandError })
  use json <- result.try(result)
  doc.from_json(json) |> result.map_error(fn(_) { DecodeError })
}
