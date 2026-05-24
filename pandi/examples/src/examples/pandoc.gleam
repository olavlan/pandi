import pandi/doc
import shellout
import simplifile

const folder = "resources/"

pub fn file_to_document(
  from_file filename: String,
  from_format from_format: String,
) -> doc.Document {
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-f", from_format, "-t", "json", folder <> filename],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
  let assert Ok(document) = doc.from_json(result)
  document
}

pub fn document_to_file(
  document: doc.Document,
  to_file filename: String,
  to_format to_format,
) {
  let json_file = folder <> filename <> ".json"
  let assert Ok(_) =
    simplifile.write(to: json_file, contents: doc.to_json(document))
  let assert Ok(_) =
    shellout.command(
      run: "pandoc",
      with: ["-f", "json", "-t", to_format, "-o", folder <> filename, json_file],
      in: ".",
      opt: [],
    )
  let assert Ok(_) = simplifile.delete(json_file)
}
