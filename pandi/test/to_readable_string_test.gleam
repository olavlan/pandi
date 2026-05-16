import birdie
import pandi as pd

fn snapshot(blocks: List(pd.Block), title: String) {
  pd.Document(blocks, [])
  |> pd.to_readable_string
  |> birdie.snap(title: "[to_readable_string] " <> title)
}

pub fn paragraph_test() {
  [
    pd.Header(1, pd.Attributes("", [], []), []),
  ]
  |> snapshot("paragraph")
}
