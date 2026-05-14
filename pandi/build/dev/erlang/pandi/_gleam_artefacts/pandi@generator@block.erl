-module(pandi@generator@block).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/generator/block.gleam").
-export([block_generator/0]).

-file("src/pandi/generator/block.gleam", 37).
-spec code_block_generator() -> qcheck:generator(pandi@pandoc:block()).
code_block_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        pandi@generator@shared:word_generator(),
        fun(Attributes, Text) -> {code_block, Attributes, Text} end
    ).

-file("src/pandi/generator/block.gleam", 28).
-spec header_generator() -> qcheck:generator(pandi@pandoc:block()).
header_generator() ->
    qcheck:map3(
        qcheck:bounded_int(1, 6),
        pandi@generator@shared:attributes_generator(),
        pandi@generator@inline:inlines_generator(),
        fun(Level, Attributes, Content) ->
            {header, Level, Attributes, Content}
        end
    ).

-file("src/pandi/generator/block.gleam", 18).
-spec plain_generator() -> qcheck:generator(pandi@pandoc:block()).
plain_generator() ->
    qcheck:map(
        pandi@generator@inline:inlines_generator(),
        fun(Content) -> {plain, Content} end
    ).

-file("src/pandi/generator/block.gleam", 23).
-spec para_generator() -> qcheck:generator(pandi@pandoc:block()).
para_generator() ->
    qcheck:map(
        pandi@generator@inline:inlines_generator(),
        fun(Content) -> {para, Content} end
    ).

-file("src/pandi/generator/block.gleam", 75).
-spec leaf_generator() -> qcheck:generator(pandi@pandoc:block()).
leaf_generator() ->
    qcheck:from_generators(
        para_generator(),
        [plain_generator(), header_generator(), code_block_generator()]
    ).

-file("src/pandi/generator/block.gleam", 71).
-spec leafs_generator() -> qcheck:generator(list(pandi@pandoc:block())).
leafs_generator() ->
    qcheck:generic_list(leaf_generator(), qcheck:bounded_int(1, 3)).

-file("src/pandi/generator/block.gleam", 66).
-spec block_quote_generator() -> qcheck:generator(pandi@pandoc:block()).
block_quote_generator() ->
    qcheck:map(leafs_generator(), fun(Content) -> {block_quote, Content} end).

-file("src/pandi/generator/block.gleam", 101).
-spec list_number_delimiter_generator() -> qcheck:generator(pandi@pandoc:list_number_delimiter()).
list_number_delimiter_generator() ->
    qcheck:from_generators(
        qcheck:return(period),
        [qcheck:return(one_paren), qcheck:return(two_parens)]
    ).

-file("src/pandi/generator/block.gleam", 92).
-spec list_number_style_generator() -> qcheck:generator(pandi@pandoc:list_number_style()).
list_number_style_generator() ->
    qcheck:from_generators(
        qcheck:return(decimal),
        [qcheck:return(lower_alpha),
            qcheck:return(upper_alpha),
            qcheck:return(lower_roman),
            qcheck:return(upper_roman)]
    ).

-file("src/pandi/generator/block.gleam", 83).
-spec list_attributes_generator() -> qcheck:generator(pandi@pandoc:list_attributes()).
list_attributes_generator() ->
    qcheck:map3(
        qcheck:return(1),
        list_number_style_generator(),
        list_number_delimiter_generator(),
        fun(Start, Style, Delimiter) ->
            {list_attributes, Start, Style, Delimiter}
        end
    ).

-file("src/pandi/generator/block.gleam", 58).
-spec ordered_list_generator() -> qcheck:generator(pandi@pandoc:block()).
ordered_list_generator() ->
    qcheck:map2(
        list_attributes_generator(),
        qcheck:generic_list(leafs_generator(), qcheck:bounded_int(2, 5)),
        fun(Attributes, Items) -> {ordered_list, Attributes, Items} end
    ).

-file("src/pandi/generator/block.gleam", 50).
-spec bullet_list_generator() -> qcheck:generator(pandi@pandoc:block()).
bullet_list_generator() ->
    qcheck:map(
        qcheck:generic_list(leafs_generator(), qcheck:bounded_int(2, 5)),
        fun(Items) -> {bullet_list, Items} end
    ).

-file("src/pandi/generator/block.gleam", 42).
-spec div_generator() -> qcheck:generator(pandi@pandoc:block()).
div_generator() ->
    qcheck:map2(
        pandi@generator@shared:attributes_generator(),
        leafs_generator(),
        fun(Attributes, Content) -> {'div', Attributes, Content} end
    ).

-file("src/pandi/generator/block.gleam", 6).
-spec block_generator() -> qcheck:generator(pandi@pandoc:block()).
block_generator() ->
    qcheck:from_generators(
        para_generator(),
        [plain_generator(),
            header_generator(),
            code_block_generator(),
            div_generator(),
            bullet_list_generator(),
            ordered_list_generator(),
            block_quote_generator()]
    ).
