Gleam packages for working with Pandoc-compatible documents:

* [pandi](./pandi): Core package including a module for filtering.
* [pandoc-lustre-converter](./pandoc_lustre_converter): Document to Lustre converter, with rendering hooks.
* [qcheck-pandoc](./qcheck_pandoc): Random document generator.

Tasks, pandi:

* Add integration test folder

Tasks, pandoc-lustre-converter:

* ask for feedback on implementation

Tasks, other:

* adhere to all Gleam conventions
* test both targets in justfile
* support all element types

Future plans:

* to_string_outline
* structural diff?
