import gleam/list
import gleam/string
import gleeunit/should
import lustre/element
import pandi
import pandi/lustre.{to_lustre}
import simplifile

const json_folder = "test/resources/json/"

type Resource {
  Resource(pandoc_html: String, pandoc_json: String)
}

fn get_html_path(json_path: String) -> String {
  string.replace(json_path, each: "json", with: "html")
}

fn parse_resource(json_path: String) -> Resource {
  let assert Ok(pandoc_json) = simplifile.read(json_path)
  let assert Ok(pandoc_html) = simplifile.read(get_html_path(json_path))
  Resource(pandoc_html, pandoc_json)
}

fn read_resources() -> List(Resource) {
  let assert Ok(files) = simplifile.read_directory(at: json_folder)
  files
  |> list.map(fn(file) { json_folder <> file })
  |> list.map(parse_resource)
}

fn property(resource: Resource) {
  let Resource(pandoc_html, pandoc_json) = resource
  let assert Ok(document) = pandi.from_json(pandoc_json)
  to_lustre(document)
  |> element.to_string()
  |> should.equal(pandoc_html)
}

pub fn lustre_test() {
  read_resources()
  |> list.each(property)
}
