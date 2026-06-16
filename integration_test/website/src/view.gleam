import component.{PostItem}
import gleam/dict
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import model.{type Message, type Model}
import pandi/doc
import pandoc_lustre_converter as pl
import route

pub fn view(model: Model) -> Element(Message) {
  component.container([
    component.content([
      {
        case model.route {
          route.Index -> view_post_list(model)
          route.Posts -> view_post_list(model)
          route.PostById(post_id) -> view_post(model, post_id)
          route.About -> view_post_list(model)
          route.NotFound(_) -> view_post_list(model)
        }
      },
    ]),
  ])
}

fn view_post_list(model: Model) -> Element(message) {
  let assert Ok(posts) = model.posts
  let items =
    dict.to_list(posts)
    |> list.map(fn(entry) {
      let #(id, post) = entry
      PostItem(
        title: post.title,
        route: route.PostById(id),
        date: post.date_created,
      )
    })
  component.post_listing(items)
}

fn view_post(model: Model, post_id: String) -> Element(message) {
  case model.posts {
    Ok(posts) ->
      case dict.get(posts, post_id) {
        Error(_) -> view_post_list(model)
        Ok(post) ->
          component.prose([
            pl.convert_document(
              post.document,
              block_converter(),
              inline_renderer(),
            ),
          ])
      }
    Error(Nil) -> view_post_list(model)
  }
}

fn block_converter() -> pl.BlockConverter(message) {
  fn(block, _) {
    case block {
      doc.Div(_, [doc.Header(_, _, inlines), ..rest]) -> {
        use title <- pl.default_inlines(inlines)
        use content <- pl.default_blocks(rest)
        component.details(title, content) |> pl.custom
      }
      _ -> pl.default
    }
  }
}

fn inline_renderer() -> pl.InlineConverter(message) {
  fn(inline, _) {
    case inline {
      doc.Span(
        doc.Attributes(_, _, [#("definition", definition_text)]),
        inlines,
      ) -> {
        use term <- pl.default_inlines(inlines)
        component.definition(definition_text, term) |> pl.custom
      }
      doc.Str("gh:" <> repo) -> {
        html.a([attribute.href("https://github.com/" <> repo)], [
          html.text(repo),
        ])
        |> pl.custom
      }
      _ -> pl.default
    }
  }
}
