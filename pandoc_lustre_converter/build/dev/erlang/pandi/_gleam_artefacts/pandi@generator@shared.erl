-module(pandi@generator@shared).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/generator/shared.gleam").
-export([word_generator/0, attributes_generator/0]).

-file("src/pandi/generator/shared.gleam", 4).
-spec word_generator() -> qcheck:generator(binary()).
word_generator() ->
    qcheck:generic_string(
        qcheck:lowercase_ascii_codepoint(),
        qcheck:bounded_int(3, 5)
    ).

-file("src/pandi/generator/shared.gleam", 20).
-spec keyvalue_generator() -> qcheck:generator({binary(), binary()}).
keyvalue_generator() ->
    qcheck:map2(
        word_generator(),
        word_generator(),
        fun(Key, Value) -> {Key, Value} end
    ).

-file("src/pandi/generator/shared.gleam", 11).
-spec attributes_generator() -> qcheck:generator(pandi@pandoc:attributes()).
attributes_generator() ->
    qcheck:map3(
        qcheck:from_generators(word_generator(), [qcheck:return(<<""/utf8>>)]),
        qcheck:generic_list(word_generator(), qcheck:bounded_int(0, 2)),
        qcheck:generic_list(keyvalue_generator(), qcheck:bounded_int(0, 1)),
        fun(Identifier, Classes, Keyvalues) ->
            {attributes, Identifier, Classes, Keyvalues}
        end
    ).
