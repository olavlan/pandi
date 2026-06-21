# You don't need a static site generator

I'm tired of static site generators and more generally, the concept of creating anything through configuration files.

After discovering Gleam and Lustre, I wanted to figure out if importing my static blog posts could be a easy as:

./integration_test/website/src/model.gleam:model

A single json file holds all my blog posts, and it can be hosted anywhere (here I have chosen Github Gist).
