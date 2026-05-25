import examples/pandoc
import pandi/doc
import pandi/filter

pub fn main() {
  let change_ordered_to_bullet_list: filter.BlockFilter = fn(block, _meta) {
    case block {
      doc.OrderedList(_, items) -> [doc.BulletList(items)] |> filter.replace
      _ -> filter.keep
    }
  }

  let empty_attributes = doc.Attributes(id: "", classes: [], keyvalues: [])
  let insert_github_links: filter.InlineFilter = fn(inline, _meta) {
    case inline {
      doc.Str("gh:" <> repo) ->
        [
          doc.Link(
            attributes: empty_attributes,
            content: doc.text(repo <> " 🔗"),
            target: doc.Target(
              url: "https://github.com/" <> repo,
              title: repo <> " at Github",
            ),
          ),
        ]
        |> filter.replace
      _ -> filter.keep
    }
  }

  let list_attributes = doc.ListAttributes(1, doc.Decimal, doc.Period)
  let document =
    doc.Document(
      blocks: [
        doc.OrderedList(list_attributes, [
          [doc.Plain([doc.Str("gh:lustre-labs/lustre")])],
          [doc.Plain([doc.Str("gh:gleam-wisp/wisp")])],
          [doc.Plain([doc.Str("gh:giacomocavalieri/squirrel")])],
        ]),
      ],
      meta: [],
    )

  document
  |> filter.apply_block_filter(change_ordered_to_bullet_list)
  |> filter.apply_inline_filter(insert_github_links)
  |> pandoc.document_to_file(
    to_file: "complete_example.html",
    to_format: "html",
  )
}
