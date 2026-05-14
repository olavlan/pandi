
# Increase header level

This example creates a block filter that increases all header levels by one.

```sh
echo '# Hello' | pandoc -f markdown -t json | gleam run -m filter | pandoc -f json -t html
# <h2 id="hello">Hello</h2>
```
