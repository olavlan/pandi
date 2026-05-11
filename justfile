# list available commands
default:
    @just --list

# run all checks 
check:
    gleam check && gleam fix && gleam test && gleam format

# run tests with updates resources
test:
    @just resources && gleam test

# review snapshots
snapshots:
  gleam run -m birdie

# generate test resources
resources:
    #!/usr/bin/env bash
    for file in test/resources/md/*.md; do
        base="$(basename "$file" .md)"
        pandoc --from markdown --to json "$file" > "test/resources/json/${base}.json"
    done

# test document generator
generator:
    gleam run -m sample 2>/dev/null | pandoc --from json --to markdown

# convert markdown string to pandoc
md-to-pandoc content:
    echo "{{ content }}" | pandoc --from markdown --to json



