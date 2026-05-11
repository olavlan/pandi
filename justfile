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

# Convert all .md files in test/resources/md/ to pandoc JSON AST and HTML
convert-test-resources:
    #!/usr/bin/env bash
    for file in test/resources/md/*.md; do
        base="$(basename "$file" .md)"
        pandoc --from markdown --to json "$file" > "test/resources/json/${base}.json"
        pandoc --from markdown --to html "$file" > "test/resources/html/${base}.html"
    done

# Run tests (regenerates resources first)
test:
    just convert-test-resources && gleam test

# review snapshots
birdie:
  gleam run -m birdie
