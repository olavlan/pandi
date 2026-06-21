# You don't need a static site generator

I'm tired of static site generators and more generally, the concept of creating anything through configuration files.

After discovering Gleam and Lustre, I wanted to figure out if importing my static blog posts could be a easy as:

````gleam
const blog_url = "https://gist.githubusercontent.com/olavlan/ac7edd6ff70bf72515bb12e67787b84a/raw/posts.json"

pub type Model {
  Model(posts: Result(Dict(String, Post), Nil), route: route.Route)
}

pub type Post {
  Post(title: String, date_created: String, document: doc.Document)
}
````

A single json file holds all my blog posts, and it can be hosted anywhere (here I have chosen Github Gist).