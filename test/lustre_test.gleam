import birdie
import lustre/element
import pandi
import pandi/lustre.{to_lustre}
import simplifile

type TestResource {
  TestResource(pandoc_html: String, pandoc_json: String)
}

fn read_resource(name: String) -> TestResource {
  let assert Ok(pandoc_html) =
    simplifile.read("test/resources/" <> name <> ".html")
  let assert Ok(pandoc_json) =
    simplifile.read("test/resources/" <> name <> ".json")
  TestResource(pandoc_html, pandoc_json)
}

fn snapshot(resource_name: String) {
  let TestResource(_, pandoc_json) = read_resource(resource_name)
  let assert Ok(document) = pandi.from_json(pandoc_json)
  to_lustre(document)
  |> element.to_readable_string()
  |> birdie.snap(title: "[to_lustre] " <> resource_name)
}

pub fn paragraph_test() {
  snapshot("paragraph")
}

pub fn bullet_list_test() {
  snapshot("bullet_list")
}

pub fn code_block_test() {
  snapshot("code_block")
}

pub fn div_test() {
  snapshot("div")
}

pub fn emph_test() {
  snapshot("emph")
}

pub fn header_test() {
  snapshot("header")
}

pub fn inline_code_test() {
  snapshot("inline_code")
}

pub fn line_break_test() {
  snapshot("line_break")
}

pub fn link_test() {
  snapshot("link")
}

pub fn ordered_list_test() {
  snapshot("ordered_list")
}

pub fn soft_break_test() {
  snapshot("soft_break")
}

pub fn span_test() {
  snapshot("span")
}

pub fn strikeout_test() {
  snapshot("strikeout")
}

pub fn strong_test() {
  snapshot("strong")
}
