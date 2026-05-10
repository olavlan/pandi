import gleeunit/should
import pandi
import pandi/pandoc as pd
import simplifile

fn read_resource(name: String) -> String {
  let assert Ok(json) = simplifile.read("test/resources/" <> name <> ".json")
  json
}

pub fn paragraph_decode_test() {
  let result = pandi.from_json(read_resource("paragraph"))
  let doc = result |> should.be_ok
  doc.blocks
  |> should.equal([pd.Para([pd.Str("Hello"), pd.Space, pd.Str("world")])])
}

pub fn header_decode_test() {
  let result = pandi.from_json(read_resource("header"))
  let doc = result |> should.be_ok
  let assert [pd.Header(level, attrs, content)] = doc.blocks
  level |> should.equal(1)
  attrs.id |> should.equal("hello-world")
  content |> should.equal([pd.Str("Hello"), pd.Space, pd.Str("world")])
}

pub fn div_decode_test() {
  let result = pandi.from_json(read_resource("div"))
  let doc = result |> should.be_ok
  let assert [pd.Div(attrs, content)] = doc.blocks
  attrs.classes |> should.equal(["mydiv"])
  content
  |> should.equal([pd.Para([pd.Str("Hello"), pd.Space, pd.Str("world")])])
}

pub fn bullet_list_decode_test() {
  let result = pandi.from_json(read_resource("bullet_list"))
  let doc = result |> should.be_ok
  let assert [pd.BulletList(items)] = doc.blocks
  items
  |> should.equal([
    [pd.Plain([pd.Str("Item"), pd.Space, pd.Str("1")])],
    [pd.Plain([pd.Str("Item"), pd.Space, pd.Str("2")])],
    [pd.Plain([pd.Str("Item"), pd.Space, pd.Str("3")])],
  ])
}

pub fn code_block_decode_test() {
  let result = pandi.from_json(read_resource("code_block"))
  let doc = result |> should.be_ok
  let assert [pd.CodeBlock(attrs, text)] = doc.blocks
  attrs.classes |> should.equal(["python"])
  text |> should.equal("print(\"hello\")")
}

pub fn link_decode_test() {
  let result = pandi.from_json(read_resource("link"))
  let doc = result |> should.be_ok
  let assert [pd.Para([pd.Link(attrs, content, target)])] = doc.blocks
  attrs.id |> should.equal("")
  content |> should.equal([pd.Str("Click"), pd.Space, pd.Str("here")])
  target.url |> should.equal("https://example.com")
  target.title |> should.equal("My Title")
}
