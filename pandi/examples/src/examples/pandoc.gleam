import pandi.{type Document, from_json, to_json}
import shellout
import simplifile

pub fn parse_raw(raw_document: String, format: String) -> Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = from_json(result)
  document
}

pub fn render_raw(document: Document, format: String) -> String {
  let json = to_json(document)
  let cmd = "echo '" <> json <> "' | pandoc -f json -t " <> format
  let assert Ok(html) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  html
}

pub fn parse(input_path: String) -> Document {
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-t", "json", input_path],
      in: ".",
      opt: [shellout.LetBeStderr],
    )
  let assert Ok(document) = from_json(result)
  document
}

pub fn render(document: Document, output_path: String) -> String {
  let json = to_json(document)
  let json_file_path = "./" <> output_path <> ".json"
  let assert Ok(_) = simplifile.write(to: json_file_path, contents: json)
  let assert Ok(result) =
    shellout.command(
      run: "pandoc",
      with: ["-f", "json", "-o", output_path, json_file_path],
      in: ".",
      opt: [],
    )
  result
}
