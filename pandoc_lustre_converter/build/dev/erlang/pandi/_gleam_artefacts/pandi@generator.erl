-module(pandi@generator).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/generator.gleam").
-export([document_generator/0]).

-file("src/pandi/generator.gleam", 5).
-spec document_generator() -> qcheck:generator(pandi@pandoc:document()).
document_generator() ->
    qcheck:map(
        qcheck:generic_list(
            pandi@generator@block:block_generator(),
            qcheck:bounded_int(5, 10)
        ),
        fun(Blocks) -> {document, Blocks, []} end
    ).
