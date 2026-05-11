import birdie
import gleam/string
import gleeunit/should
import pandi
import simplifile

type TestResource {
  TestResource(markdown: String, json: String)
}

fn read_resource(name: String) -> TestResource {
  let assert Ok(markdown) = simplifile.read("test/resources/" <> name <> ".md")
  let assert Ok(json) = simplifile.read("test/resources/" <> name <> ".json")
  TestResource(markdown, json)
}

fn decode_snapshot(resource_name: String) {
  let TestResource(markdown, json) = read_resource(resource_name)
  pandi.from_json(json)
  |> should.be_ok
  |> string.inspect
  |> birdie.snap(title: "Decode " <> resource_name <> ":\n" <> markdown)
}

pub fn paragraph_test() {
  decode_snapshot("paragraph")
}

pub fn bullet_list_test() {
  decode_snapshot("bullet_list")
}

pub fn code_block_test() {
  decode_snapshot("code_block")
}

pub fn div_test() {
  decode_snapshot("div")
}

pub fn emph_test() {
  decode_snapshot("emph")
}

pub fn header_test() {
  decode_snapshot("header")
}

pub fn inline_code_test() {
  decode_snapshot("inline_code")
}

pub fn line_break_test() {
  decode_snapshot("line_break")
}

pub fn link_test() {
  decode_snapshot("link")
}

pub fn ordered_list_test() {
  decode_snapshot("ordered_list")
}

pub fn soft_break_test() {
  decode_snapshot("soft_break")
}

pub fn span_test() {
  decode_snapshot("span")
}

pub fn strikeout_test() {
  decode_snapshot("strikeout")
}

pub fn strong_test() {
  decode_snapshot("strong")
}
