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

pub fn paragraph_test() {
  let TestResource(markdown, json) = read_resource("paragraph")
  pandi.from_json(json)
  |> should.be_ok
  |> string.inspect
  |> birdie.snap(title: markdown)
}
