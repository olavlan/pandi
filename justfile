default:
    @just --list

packages := "pandi pandoc_lustre_converter qcheck_pandoc"
published := "pandi pandoc_lustre_converter"

# installs the pre-commit hook 
install-hook:
    @printf '#!/usr/bin/env sh\nset -e\njust pre-commit\ngit add -A\n' > .git/hooks/pre-commit
    @chmod +x .git/hooks/pre-commit
    @echo "pre-commit hook installed"

pre-commit:
    @just check
    @just generate-resources
    @just test
    @just generate-readme

# run checks across all packages 
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

# run tests across all packages
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

# review all new snapshots
snapshots:
    #!/usr/bin/env sh
    for pkg in {{ published }}; do
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
    done

# generate random markdown document
generate-markdown:
    #!/usr/bin/env sh
    cd qcheck_pandoc
    gleam run -m qcheck_pandoc/generate_markdown 2>/dev/null | pandoc --from json --to markdown

render_readme := "sed -E 's/\\{\\{([^}]+)\\}\\}/cat \\1/e' README.template.md > README.md"

# generate README-files from templates across all packages
generate-readme:
    #!/usr/bin/env sh
    for pkg in {{ packages }}; do
        (
            cd "$pkg"
            {{ render_readme }}
        )
    done
