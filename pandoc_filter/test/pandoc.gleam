import shellout

pub fn convert(
  raw_document: String,
  input_format: String,
  output_format: String,
) -> String {
  let cmd =
    "echo '"
    <> raw_document
    <> "' | pandoc -f "
    <> input_format
    <> " -t "
    <> output_format
  let assert Ok(result) =
    shellout.command(run: "sh", with: ["-c", cmd], in: ".", opt: [])
  result
}
