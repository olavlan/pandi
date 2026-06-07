import pandi/doc

pub fn main() {
  let document =
    doc.Document(
      blocks: [
        doc.OrderedList(
          attributes: doc.ListAttributes(1, doc.Decimal, doc.Period),
          items: [
            [doc.Plain(doc.text("First item"))],
            [doc.Plain(doc.text("Second item"))],
          ],
        ),
      ],
      meta: [],
    )

  doc.to_string(document)
  // [
  //   OrderedList
  //     ( 1 , Decimal , Period )
  //     [
  //       [ Plain [ Str "First" , Space , Str "item" ] ] ,
  //       [ Plain [ Str "Second" , Space , Str "item" ] ] ,
  //     ] ,
  // ]
}
