import birdie
import pandi as pd

fn snapshot(blocks: List(pd.Block), title: String) {
  pd.Document(blocks, [])
  |> pd.to_string
  |> birdie.snap(title: "[to_string] " <> title)
}

pub fn paragraph_test() {
  [
    pd.Header(1, pd.Attributes("test", ["class1", "class2"], []), []),
    pd.Para([]),
    pd.Para([]),
    pd.Para([]),
  ]
  |> snapshot("paragraph")
}
