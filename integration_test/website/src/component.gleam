import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html
import route

pub fn container(children: List(Element(message))) -> Element(message) {
  html.div([class("container mx-auto max-w-5xl px-8")], children)
}

pub fn content(children: List(Element(message))) -> Element(message) {
  html.main([class("my-16")], children)
}

pub fn prose(children: List(Element(message))) -> Element(message) {
  html.article([class("prose")], children)
}

pub type Link {
  Link(target: route.Route, label: String)
}

pub fn link(link: Link) -> Element(message) {
  html.a([route.to_href(link.target)], [html.text(link.label)])
}

pub type PostItem {
  PostItem(title: String, route: route.Route, date: String)
}

pub fn post_listing(post_items: List(PostItem)) -> Element(message) {
  let list_items =
    list.map(post_items, fn(item) {
      html.li([], [
        html.a([route.to_href(item.route), class("link hover:underline")], [
          html.text(item.title),
        ]),
        html.span([class("text-sm opacity-50 ml-2")], [html.text(item.date)]),
      ])
    })
  html.ul([class("list")], list_items)
}

pub fn details(
  summary summary: Element(message),
  content content: Element(message),
) -> Element(message) {
  html.details(
    [class("collapse collapse-arrow bg-base-100 border border-base-300")],
    [
      html.summary([class("collapse-title font-semibold")], [summary]),
      html.div([class("collapse-content")], [content]),
    ],
  )
}

pub fn definition(
  definition definition: String,
  term term: Element(message),
) -> Element(message) {
  html.span(
    [
      class("tooltip tooltip-top"),
      attribute.attribute("data-tip", definition),
    ],
    [term],
  )
}
