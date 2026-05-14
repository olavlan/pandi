default:
    @just --list

packages := "pandi pandoc_lustre_converter qcheck_pandoc"
published := "pandi pandoc_lustre_converter"

pre-commit:
    @just check
    @just generate-resources
    @just test
    @just generate-readme

check:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            gleam check
            gleam fix
            gleam format
        )
    done

test:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            gleam test
            cd examples
            gleam run
        )
    done

snapshots:
    #!/usr/bin/env sh
    for pkg in {{ published }}; do
        (
            cd "$pkg"
            gleam run -m birdie
        )
    done

generate-resources:
    #!/usr/bin/env sh
    cd pandi
    for file in test/resources/md/*.md; do
        base="$(basename "$file" .md)"
        pandoc --from markdown --to json "$file" > "test/resources/json/${base}.json"
    done

generate-markdown:
    #!/usr/bin/env sh
    cd qcheck_pandoc
    gleam run -m qcheck_pandoc/generate_markdown 2>/dev/null | pandoc --from json --to markdown

render_readme := "sed -E 's/\\{\\{([^}]+)\\}\\}/cat \\1/e' README.template.md > README.md"

generate-readme:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            {{ render_readme }}
        )
    done
