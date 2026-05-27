import pandi/doc
import shellout

pub fn parse(raw_document: String, format: String) -> doc.Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = doc.from_json(result)
  document
}
