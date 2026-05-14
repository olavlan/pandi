-module(pandi@generator@inlines).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/generator/inlines.gleam").
-export([inlines_generator/0]).

-file("src/pandi/generator/inlines.gleam", 96).
-spec target_generator() -> qcheck:generator(pandi@pandoc:target()).
target_generator() ->
    qcheck:map2(
        pandi@generator@shared:tiny_string_generator(),
        pandi@generator@shared:tiny_string_generator(),
        fun(Field@0, Field@1) -> {target, Field@0, Field@1} end
    ).

-file("src/pandi/generator/inlines.gleam", 35).
-spec str_generator() -> qcheck:generator(pandi@pandoc:inline()).
str_generator() ->
    qcheck:map(
        pandi@generator@shared:tiny_string_generator(),
        fun(Field@0) -> {str, Field@0} end
    ).

-file("src/pandi/generator/inlines.gleam", 92).
-spec soft_break_generator() -> qcheck:generator(pandi@pandoc:inline()).
soft_break_generator() ->
    qcheck:return(soft_break).

-file("src/pandi/generator/inlines.gleam", 39).
-spec space_generator() -> qcheck:generator(pandi@pandoc:inline()).
space_generator() ->
    qcheck:return(space).

-file("src/pandi/generator/inlines.gleam", 84).
-spec word_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
word_generator() ->
    qcheck:map2(
        str_generator(),
        qcheck:from_generators(space_generator(), [soft_break_generator()]),
        fun(Word, Sep) -> [Word, Sep] end
    ).

-file("src/pandi/generator/inlines.gleam", 76).
-spec leaf_inlines_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
leaf_inlines_generator() ->
    qcheck:map2(
        qcheck:generic_list(word_generator(), qcheck:bounded_int(1, 3)),
        str_generator(),
        fun(Words, Last) -> lists:append(lists:append(Words), [Last]) end
    ).

-file("src/pandi/generator/inlines.gleam", 67).
-spec link_generator() -> qcheck:generator(pandi@pandoc:inline()).
link_generator() ->
    qcheck:map3(
        pandi@generator@shared:attributes_generator(),
        leaf_inlines_generator(),
        target_generator(),
        fun(Field@0, Field@1, Field@2) -> {link, Field@0, Field@1, Field@2} end
    ).

-file("src/pandi/generator/inlines.gleam", 63).
-spec span_generator() -> qcheck:generator(pandi@pandoc:inline()).
span_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        leaf_inlines_generator(),
        fun(Field@0, Field@1) -> {span, Field@0, Field@1} end
    ).

-file("src/pandi/generator/inlines.gleam", 59).
-spec code_inline_generator() -> qcheck:generator(pandi@pandoc:inline()).
code_inline_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        pandi@generator@shared:tiny_string_generator(),
        fun(Field@0, Field@1) -> {code, Field@0, Field@1} end
    ).

-file("src/pandi/generator/inlines.gleam", 55).
-spec strikeout_generator() -> qcheck:generator(pandi@pandoc:inline()).
strikeout_generator() ->
    qcheck:map(
        leaf_inlines_generator(),
        fun(Field@0) -> {strikeout, Field@0} end
    ).

-file("src/pandi/generator/inlines.gleam", 51).
-spec strong_generator() -> qcheck:generator(pandi@pandoc:inline()).
strong_generator() ->
    qcheck:map(leaf_inlines_generator(), fun(Field@0) -> {strong, Field@0} end).

-file("src/pandi/generator/inlines.gleam", 47).
-spec emph_generator() -> qcheck:generator(pandi@pandoc:inline()).
emph_generator() ->
    qcheck:map(leaf_inlines_generator(), fun(Field@0) -> {emph, Field@0} end).

-file("src/pandi/generator/inlines.gleam", 43).
-spec line_break_generator() -> qcheck:generator(pandi@pandoc:inline()).
line_break_generator() ->
    qcheck:return(line_break).

-file("src/pandi/generator/inlines.gleam", 22).
-spec inline_generator() -> qcheck:generator(pandi@pandoc:inline()).
inline_generator() ->
    qcheck:from_generators(
        str_generator(),
        [space_generator(),
            line_break_generator(),
            emph_generator(),
            strong_generator(),
            strikeout_generator(),
            code_inline_generator(),
            span_generator(),
            link_generator()]
    ).

-file("src/pandi/generator/inlines.gleam", 14).
-spec inline_segment_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
inline_segment_generator() ->
    qcheck:map2(
        inline_generator(),
        qcheck:from_generators(space_generator(), [soft_break_generator()]),
        fun(Segment, Sep) -> [Segment, Sep] end
    ).

-file("src/pandi/generator/inlines.gleam", 6).
-spec inlines_generator() -> qcheck:generator(list(pandi@pandoc:inline())).
inlines_generator() ->
    qcheck:map2(
        qcheck:generic_list(
            inline_segment_generator(),
            qcheck:bounded_int(1, 3)
        ),
        inline_generator(),
        fun(Segments, Last) -> lists:append(lists:append(Segments), [Last]) end
    ).
