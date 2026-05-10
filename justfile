# List available commands
default:
    @just --list

# Convert markdown to pandoc JSON AST
md-to-pandoc content:
    echo "{{ content }}" | pandoc --from markdown --to json

# Convert all .md files in test/resources/ to pandoc JSON AST
convert-test-resources:
    #!/usr/bin/env bash
    for file in test/resources/*.md; do pandoc --from markdown --to json "$file" > "${file%.md}.json"; done