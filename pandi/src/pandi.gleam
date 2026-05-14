import gleam/json
import pandi/decode
import pandi/encode
import pandi/pandoc as pd

pub fn to_json(doc: pd.Document) -> String {
  doc
  |> encode.encode_document
  |> json.to_string
}

pub fn from_json(json_string: String) -> Result(pd.Document, json.DecodeError) {
  json.parse(from: json_string, using: decode.document_decoder())
}
