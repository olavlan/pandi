import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import lustre/effect.{type Effect}
import modem
import pandi/doc
import route
import rsvp

//model
const blog_url = "https://gist.githubusercontent.com/olavlan/ac7edd6ff70bf72515bb12e67787b84a/raw/posts.json"

pub type Model {
  Model(posts: Result(Dict(String, Post), Nil), route: route.Route)
}

pub type Post {
  Post(title: String, date_created: String, document: doc.Document)
}

//model

pub type Message {
  UserNavigatedTo(route: route.Route)
  PostsFetched(Result(String, rsvp.Error))
}

pub fn init(_) -> #(Model, Effect(Message)) {
  let route = case modem.initial_uri() {
    Ok(uri) -> route.from_uri(uri)
    Error(_) -> route.NotFound
  }

  let modem_effect =
    modem.init(fn(uri) { route.from_uri(uri) |> UserNavigatedTo })

  #(
    Model(posts: Error(Nil), route:),
    effect.batch([modem_effect, fetch_posts()]),
  )
}

pub fn update(model: Model, message: Message) -> #(Model, Effect(Message)) {
  case message {
    UserNavigatedTo(route:) -> #(Model(..model, route:), effect.none())

    PostsFetched(Ok(body)) -> {
      let decoded =
        json.parse(body, decode.dict(decode.string, post_decoder()))
        |> result.map(sanitize_keys)
      case decoded {
        Ok(posts) -> #(Model(..model, posts: Ok(posts)), effect.none())
        Error(_) -> #(Model(..model, posts: Error(Nil)), effect.none())
      }
    }

    PostsFetched(Error(_)) -> #(
      Model(..model, posts: Error(Nil)),
      effect.none(),
    )
  }
}

fn fetch_posts() -> Effect(Message) {
  rsvp.get(blog_url, rsvp.expect_text(PostsFetched))
}

fn post_decoder() -> decode.Decoder(Post) {
  use date_created <- decode.field("date_created", decode.string)
  use document <- decode.field("pandoc", doc.decoder())
  let title = get_title(document)
  decode.success(Post(title:, date_created:, document:))
}

fn get_title(document: doc.Document) -> String {
  case document.blocks {
    [doc.Header(..) as first, ..] -> doc.get_text(first)
    [first, ..] ->
      doc.get_text(first)
      |> string.slice(at_index: 0, length: 30)
      |> string.append("...")
    [] -> "Untitled"
  }
}

fn sanitize_keys(input: dict.Dict(String, a)) -> dict.Dict(String, a) {
  dict.to_list(input)
  |> list.map(fn(item) {
    let key = string.replace(in: item.0, each: ".", with: "-")
    #(key, item.1)
  })
  |> dict.from_list
}
