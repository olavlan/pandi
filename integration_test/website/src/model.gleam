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

pub type Model {
  Model(posts: Result(Dict(String, Post), Nil), route: route.Route)
}

pub type Message {
  UserNavigatedTo(route: route.Route)
  PostsFetched(Result(String, rsvp.Error))
}

pub type Post {
  Post(title: String, date_created: String, document: doc.Document)
}

pub fn init(_) -> #(Model, Effect(Message)) {
  let route = case modem.initial_uri() {
    Ok(uri) -> route.parse_route(uri)
    Error(_) -> route.Index
  }

  let modem_effect =
    modem.init(fn(uri) { route.parse_route(uri) |> UserNavigatedTo })

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

const blog_url = "https://raw.githubusercontent.com/olavlan/blog/master/posts.json"

fn fetch_posts() -> Effect(Message) {
  rsvp.get(blog_url, rsvp.expect_text(PostsFetched))
}

fn post_decoder() -> decode.Decoder(Post) {
  use date_created <- decode.field("date_created", decode.string)
  use document <- decode.field("pandoc", doc.decoder())
  let title =
    dict.from_list(document.meta)
    |> dict.get("title")
    |> result.unwrap(or: "No title")
  decode.success(Post(title:, date_created:, document:))
}

fn sanitize_keys(input: dict.Dict(String, a)) -> dict.Dict(String, a) {
  dict.to_list(input)
  |> list.map(fn(item) {
    let key = string.replace(in: item.0, each: ".", with: "-")
    #(key, item.1)
  })
  |> dict.from_list
}
