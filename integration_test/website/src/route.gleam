import gleam/string
import gleam/uri.{type Uri}
import lustre/attribute.{type Attribute}

const base_path = "/blog"

pub type Route {
  PostList
  PostById(id: String)
  NotFound
}

pub fn from_uri(uri: Uri) -> Route {
  case uri.path_segments(uri.path) {
    ["blog", ..rest] ->
      case rest {
        [] | [""] -> PostList
        [post_id] -> PostById(id: post_id)
        _ -> NotFound
      }
    _ -> NotFound
  }
}

pub fn to_href(route: Route) -> Attribute(message) {
  let url = case route {
    PostList -> [] |> segments_to_path
    PostById(post_id) -> [post_id] |> segments_to_path
    NotFound -> "404"
  }

  attribute.href(url)
}

fn segments_to_path(segments: List(String)) -> String {
  [base_path, ..segments] |> string.join("/")
}
