-module(pandi@generator@inline).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/generator/inline.gleam").
-export([inlines_generator/0]).

-file("src/pandi/generator/inline.gleam", 77).
-spec target_generator() -> qcheck:generator(pandi@pandoc:target()).
target_generator() ->
    qcheck:map2(
        pandi@generator@shared:word_generator(),
        pandi@generator@shared:word_generator(),
        fun(Title, Url) -> {target, Title, Url} end
    ).

-file("src/pandi/generator/inline.gleam", 40).
-spec code_generator() -> qcheck:generator(pandi@pandoc:inline()).
code_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        pandi@generator@shared:word_generator(),
        fun(Attributes, Text) -> {code, Attributes, Text} end
    ).

-file("src/pandi/generator/inline.gleam", 36).
-spec line_break_generator() -> qcheck:generator(pandi@pandoc:inline()).
line_break_generator() ->
    qcheck:return(line_break).

-file("src/pandi/generator/inline.gleam", 31).
-spec str_generator() -> qcheck:generator(pandi@pandoc:inline()).
str_generator() ->
    qcheck:map(
        pandi@generator@shared:word_generator(),
        fun(Word) -> {str, Word} end
    ).

-file("src/pandi/generator/inline.gleam", 91).
-spec leaf_generator() -> qcheck:generator(pandi@pandoc:inline()).
leaf_generator() ->
    qcheck:from_generators(
        str_generator(),
        [line_break_generator(), code_generator()]
    ).

-file("src/pandi/generator/inline.gleam", 15).
-spec separator_generator() -> qcheck:generator(pandi@pandoc:inline()).
separator_generator() ->
    qcheck:from_generators(qcheck:return(space), [qcheck:return(soft_break)]).

-file("src/pandi/generator/inline.gleam", 82).
-spec leafs_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
leafs_generator() ->
    qcheck:bind(
        qcheck:small_non_negative_int(),
        fun(Length) ->
            qcheck:map2(
                qcheck:fixed_length_list_from(separator_generator(), Length),
                qcheck:fixed_length_list_from(leaf_generator(), Length),
                fun(Separators, Segments) ->
                    gleam@list:interleave([Segments, Separators])
                end
            )
        end
    ).

-file("src/pandi/generator/inline.gleam", 68).
-spec link_generator() -> qcheck:generator(pandi@pandoc:inline()).
link_generator() ->
    qcheck:map3(
        pandi@generator@shared:attributes_generator(),
        leafs_generator(),
        target_generator(),
        fun(Attributes, Content, Target) ->
            {link, Attributes, Content, Target}
        end
    ).

-file("src/pandi/generator/inline.gleam", 60).
-spec span_generator() -> qcheck:generator(pandi@pandoc:inline()).
span_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        leafs_generator(),
        fun(Attributes, Content) -> {span, Attributes, Content} end
    ).

-file("src/pandi/generator/inline.gleam", 55).
-spec strikeout_generator() -> qcheck:generator(pandi@pandoc:inline()).
strikeout_generator() ->
    qcheck:map(leafs_generator(), fun(Content) -> {strikeout, Content} end).

-file("src/pandi/generator/inline.gleam", 50).
-spec strong_generator() -> qcheck:generator(pandi@pandoc:inline()).
strong_generator() ->
    qcheck:map(leafs_generator(), fun(Content) -> {strong, Content} end).

-file("src/pandi/generator/inline.gleam", 45).
-spec emph_generator() -> qcheck:generator(pandi@pandoc:inline()).
emph_generator() ->
    qcheck:map(leafs_generator(), fun(Content) -> {emph, Content} end).

-file("src/pandi/generator/inline.gleam", 19).
-spec non_separator_generator() -> qcheck:generator(pandi@pandoc:inline()).
non_separator_generator() ->
    qcheck:from_generators(
        str_generator(),
        [line_break_generator(),
            code_generator(),
            emph_generator(),
            strong_generator(),
            strikeout_generator(),
            span_generator(),
            link_generator()]
    ).

-file("src/pandi/generator/inline.gleam", 6).
-spec inlines_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
inlines_generator() ->
    qcheck:bind(
        qcheck:small_non_negative_int(),
        fun(Length) ->
            qcheck:map2(
                qcheck:fixed_length_list_from(separator_generator(), Length),
                qcheck:fixed_length_list_from(non_separator_generator(), Length),
                fun(Separators, Segments) ->
                    gleam@list:interleave([Segments, Separators])
                end
            )
        end
    ).
