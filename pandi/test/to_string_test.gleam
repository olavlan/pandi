import birdie
import pandi as pd

fn snapshot_block(block: pd.Block, title: String) {
  pd.Document([block], [])
  |> pd.to_string
  |> birdie.snap(title: "[to_string] " <> title)
}

pub fn paragraph_test() {
  pd.Para([pd.Str("Paragraph")])
  |> snapshot_block("paragraph with one string element")
}
