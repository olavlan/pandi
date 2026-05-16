// import birdie
// import gleam/string
// import gleeunit/should
// import pandi
// import simplifile
//
// type Resource {
//   Resource(markdown: String, json: String)
// }
//
// fn read_resource(name: String) -> Resource {
//   let assert Ok(markdown) =
//     simplifile.read("test/resources/md/" <> name <> ".md")
//   let assert Ok(json) =
//     simplifile.read("test/resources/json/" <> name <> ".json")
//   Resource(markdown, json)
// }
//
// fn snapshot(resource_name: String) {
//   let Resource(_, json) = read_resource(resource_name)
//   pandi.from_json(json)
//   |> should.be_ok
//   |> string.inspect
//   |> birdie.snap(title: "[from_json] " <> resource_name)
// }
// pub fn paragraph_test() {
//   snapshot("paragraph")
// }
//
// pub fn bullet_list_test() {
//   snapshot("bullet_list")
// }
//
// pub fn code_block_test() {
//   snapshot("code_block")
// }
//
// pub fn div_test() {
//   snapshot("div")
// }
//
// pub fn emph_test() {
//   snapshot("emph")
// }
//
// pub fn header_test() {
//   snapshot("header")
// }
//
// pub fn inline_code_test() {
//   snapshot("inline_code")
// }
//
// pub fn line_break_test() {
//   snapshot("line_break")
// }
//
// pub fn link_test() {
//   snapshot("link")
// }
//
// pub fn ordered_list_test() {
//   snapshot("ordered_list")
// }
//
// pub fn soft_break_test() {
//   snapshot("soft_break")
// }
//
// pub fn span_test() {
//   snapshot("span")
// }
//
// pub fn strikeout_test() {
//   snapshot("strikeout")
// }
//
// pub fn strong_test() {
//   snapshot("strong")
// }
//
// pub fn block_quote_test() {
//   snapshot("block_quote")
// }
