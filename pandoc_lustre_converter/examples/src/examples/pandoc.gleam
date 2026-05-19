import pandi as pd
import shellout

pub fn parse(raw_document: String, format: String) -> pd.Document {
  let cmd = "echo '" <> raw_document <> "' | pandoc -f " <> format <> " -t json"
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  let assert Ok(document) = pd.from_json(result)
  document
}
