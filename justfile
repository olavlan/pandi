# List available commands
default:
    @just --list

# Checks that should be run after making a change
check:
    gleam check && gleam fix && gleam test && gleam format

# Convert markdown to pandoc JSON AST
md-to-pandoc content:
    echo "{{ content }}" | pandoc --from markdown --to json

# Generate a random document 
generate-document:
    gleam run -m sample 2>/dev/null | pandoc --from json --to markdown

# Convert all .md files in test/resources/ to pandoc JSON AST and HTML
convert-test-resources:
    #!/usr/bin/env bash
    for file in test/resources/*.md; do
        pandoc --from markdown --to json "$file" > "${file%.md}.json"
        pandoc --from markdown --to html "$file" > "${file%.md}.html"
    done

# review snapshots
birdie:
  gleam run -m birdie
