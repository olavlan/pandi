default:
    @just --list

packages := "pandi pandoc_lustre_converter qcheck_pandoc"

# installs the pre-commit hook 
install-hook:
    printf '#!/usr/bin/env sh\nset -e\njust pre-commit\ngit add -A\n' > .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit

pre-commit:
    @just check
    @just generate-resources
    @just test
    @just integration-test
    @just generate-readme
    @just docs

# run checks across all packages 
check:
    #!/usr/bin/env sh
    set -e
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            gleam check
            gleam fix
            gleam format
        )
    done

#run integration tests
integration-test:
    #!/usr/bin/env sh
    set -e
    for dir in integration_test/*/; do
        (
            cd "$dir"
            gleam test
        )
    done

# run tests across all packages
test:
    #!/usr/bin/env sh
    set -e
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            gleam test
            cd examples
            gleam run
        )
    done

# review all new snapshots
snapshots:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            gleam run -m birdie
        )
    done

# generate test resources
generate-resources:
    #!/usr/bin/env sh
    cd pandi
    for file in test/resources/md/*.md; do
        base="$(basename "$file" .md)"
        pandoc --from markdown --to json "$file" > "test/resources/json/${base}.json"
        pandoc --from markdown --to native "$file" > "test/resources/native/${base}"
    done

# generate random markdown document
generate-markdown:
    #!/usr/bin/env sh
    cd qcheck_pandoc
    gleam run -m qcheck_pandoc/generate_markdown 2>/dev/null | pandoc --from json --to markdown


# build and collect documentation for all packages
docs:
    #!/usr/bin/env sh
    set -e
    for pkg in {{ packages }}; do
        (cd "$pkg" && gleam docs build)
    done
    rm -rf docs
    for pkg in {{ packages }}; do
        mkdir -p "docs/$pkg"
        cp -r "$pkg/build/dev/docs/$pkg/." "docs/$pkg/"
    done


# generate README-files from templates across all packages
generate-readme:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            {{ render_readme }}
        )
    done

render_readme := "sed -E 's/\\{\\{([^}]+)\\}\\}/cat \\1/e' README.template.md > README.md"

# create a code block from a reference like "./my_file.gleam#pattern"
create-code-block source-reference:
    ref="{{source-reference}}"
    file="${ref%%#*}"
    pattern="${ref##*#}"
    ext="${file##*.}"
    content="$(just extract-code "$pattern" "$file")"
    printf "```%s\n%s\n```" "$ext" "$content"

# extract code between the first two occurrences of a pattern in a file
extract-code pattern file:
    #!/usr/bin/env sh
    awk -v p="{{pattern}}" '$0 == p { inside = !inside; next } inside' "{{file}}"


