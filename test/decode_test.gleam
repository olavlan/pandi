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
  attrs.id |> should.equal("myid")
  attrs.classes |> should.equal(["mydiv"])
  attrs.keyvalues |> should.equal([#("color", "blue")])
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

pub fn ordered_list_decode_test() {
  let result = pandi.from_json(read_resource("ordered_list"))
  let doc = result |> should.be_ok
  let assert [pd.OrderedList(attrs, items)] = doc.blocks
  attrs.start |> should.equal(1)
  attrs.style |> should.equal(pd.Decimal)
  attrs.delimiter |> should.equal(pd.Period)
  items
  |> should.equal([
    [pd.Plain([pd.Str("First")])],
    [pd.Plain([pd.Str("Second")])],
    [pd.Plain([pd.Str("Third")])],
  ])
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

pub fn span_decode_test() {
  let result = pandi.from_json(read_resource("span"))
  let doc = result |> should.be_ok
  let assert [pd.Para([_, _, pd.Span(attrs, content)])] = doc.blocks
  attrs.id |> should.equal("myid")
  attrs.classes |> should.equal(["highlight"])
  attrs.keyvalues |> should.equal([#("color", "blue")])
  content |> should.equal([pd.Str("world")])
}

pub fn inline_code_decode_test() {
  let result = pandi.from_json(read_resource("inline_code"))
  let doc = result |> should.be_ok
  let assert [pd.Para([_, _, pd.Code(attrs, text)])] = doc.blocks
  attrs.classes |> should.equal([])
  text |> should.equal("inline code")
}

pub fn emph_decode_test() {
  let result = pandi.from_json(read_resource("emph"))
  let doc = result |> should.be_ok
  doc.blocks
  |> should.equal([pd.Para([pd.Emph([pd.Str("emphasized"), pd.Space, pd.Str("text")])])])
}

pub fn strong_decode_test() {
  let result = pandi.from_json(read_resource("strong"))
  let doc = result |> should.be_ok
  doc.blocks
  |> should.equal([pd.Para([pd.Strong([pd.Str("strong"), pd.Space, pd.Str("text")])])])
}

pub fn strikeout_decode_test() {
  let result = pandi.from_json(read_resource("strikeout"))
  let doc = result |> should.be_ok
  doc.blocks
  |> should.equal([pd.Para([pd.Strikeout([pd.Str("strikeout"), pd.Space, pd.Str("text")])])])
}
