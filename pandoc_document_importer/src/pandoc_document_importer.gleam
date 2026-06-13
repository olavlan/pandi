import gleam/io
import simplifile
import trick

pub fn main() {
  let document_folder = todo as "use tom to extract configured document folder"
  let document_tree = todo as "use simplifile to extract document tree"
  let document_tree_json =
    todo as "use shellout/pandoc/json to convert document tree to a single JSON object"
  let json_write_result = simplifile.write(to: "documents.json", contents: "")
  let gleam_code =
    todo as "use trick to generate gleam code to import and decode json "
  let gleam_code_write_result =
    simplifile.write(to: "documents.gleam", contents: "")
  io.println("Generated module `documents.gleam`.")
}
