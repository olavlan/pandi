-module(render_block_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/render_block_test.gleam").
-export([paragraph_test/0, header1_test/0, header2_test/0, header3_test/0, header4_test/0, header5_test/0, header6_test/0, bullet_list_test/0, ordered_list_test/0, code_block_test/0, block_quote_test/0, plain_test/0, div_test/0, div_with_attributes_test/0, header_with_attributes_test/0, code_block_with_attributes_test/0, ordered_list_different_styles_test/0, ordered_list_upper_alpha_test/0, header_default_level/0]).

-file("test/render_block_test.gleam", 6).
-spec snapshot(pandi@pandoc:block(), binary()) -> nil.
snapshot(Block, Title) ->
    _pipe = pandoc_lustre_converter:convert_blocks([Block]),
    _pipe@1 = lustre@element:to_readable_string(_pipe),
    birdie:snap(_pipe@1, <<"[render_block] "/utf8, Title/binary>>).

-file("test/render_block_test.gleam", 12).
-spec paragraph_test() -> nil.
paragraph_test() ->
    _pipe = {para, [{str, <<"Paragraph"/utf8>>}]},
    snapshot(_pipe, <<"paragraph"/utf8>>).

-file("test/render_block_test.gleam", 17).
-spec header1_test() -> nil.
header1_test() ->
    _pipe = {header,
        1,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 1"/utf8>>).

-file("test/render_block_test.gleam", 22).
-spec header2_test() -> nil.
header2_test() ->
    _pipe = {header,
        2,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 2"/utf8>>).

-file("test/render_block_test.gleam", 27).
-spec header3_test() -> nil.
header3_test() ->
    _pipe = {header,
        3,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 3"/utf8>>).

-file("test/render_block_test.gleam", 32).
-spec header4_test() -> nil.
header4_test() ->
    _pipe = {header,
        4,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 4"/utf8>>).

-file("test/render_block_test.gleam", 37).
-spec header5_test() -> nil.
header5_test() ->
    _pipe = {header,
        5,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 5"/utf8>>).

-file("test/render_block_test.gleam", 42).
-spec header6_test() -> nil.
header6_test() ->
    _pipe = {header,
        6,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Header"/utf8>>}]},
    snapshot(_pipe, <<"header level 6"/utf8>>).

-file("test/render_block_test.gleam", 47).
-spec bullet_list_test() -> nil.
bullet_list_test() ->
    _pipe = {bullet_list,
        [[{plain, [{str, <<"Item"/utf8>>}]}],
            [{plain, [{str, <<"Item"/utf8>>}]}]]},
    snapshot(_pipe, <<"bullet list with two simple items"/utf8>>).

-file("test/render_block_test.gleam", 55).
-spec ordered_list_test() -> nil.
ordered_list_test() ->
    List_attributes = {list_attributes, 1, decimal, period},
    _pipe = {ordered_list,
        List_attributes,
        [[{plain, [{str, <<"Item"/utf8>>}]}],
            [{plain, [{str, <<"Item"/utf8>>}]}]]},
    snapshot(
        _pipe,
        <<"ordered list with two items (start=1, decimal, period)"/utf8>>
    ).

-file("test/render_block_test.gleam", 64).
-spec code_block_test() -> nil.
code_block_test() ->
    _pipe = {code_block,
        {attributes, <<""/utf8>>, [], []},
        <<"let x = 1"/utf8>>},
    snapshot(_pipe, <<"code block with inline code"/utf8>>).

-file("test/render_block_test.gleam", 69).
-spec block_quote_test() -> nil.
block_quote_test() ->
    _pipe = {block_quote, [{para, [{str, <<"Quote"/utf8>>}]}]},
    snapshot(_pipe, <<"block quote with one paragraph"/utf8>>).

-file("test/render_block_test.gleam", 76).
-spec plain_test() -> nil.
plain_test() ->
    _pipe = {plain, [{str, <<"Plain text"/utf8>>}]},
    snapshot(_pipe, <<"plain text"/utf8>>).

-file("test/render_block_test.gleam", 81).
-spec div_test() -> nil.
div_test() ->
    _pipe = {'div',
        {attributes, <<""/utf8>>, [], []},
        [{para, [{str, <<"Inside div"/utf8>>}]}]},
    snapshot(_pipe, <<"div with paragraph"/utf8>>).

-file("test/render_block_test.gleam", 88).
-spec div_with_attributes_test() -> nil.
div_with_attributes_test() ->
    Attrs = {attributes,
        <<"my-id"/utf8>>,
        [<<"class1"/utf8>>, <<"class2"/utf8>>],
        [{<<"data-foo"/utf8>>, <<"bar"/utf8>>}]},
    _pipe = {'div', Attrs, [{para, [{str, <<"Attributed div"/utf8>>}]}]},
    snapshot(_pipe, <<"div with id, classes, and keyvalue attributes"/utf8>>).

-file("test/render_block_test.gleam", 97).
-spec header_with_attributes_test() -> nil.
header_with_attributes_test() ->
    Attrs = {attributes,
        <<"section-title"/utf8>>,
        [<<"heading"/utf8>>, <<"main"/utf8>>],
        [{<<"data-level"/utf8>>, <<"top"/utf8>>}]},
    _pipe = {header, 2, Attrs, [{str, <<"Attributed Header"/utf8>>}]},
    snapshot(
        _pipe,
        <<"header level 2 with id, classes, and keyvalue attributes"/utf8>>
    ).

-file("test/render_block_test.gleam", 104).
-spec code_block_with_attributes_test() -> nil.
code_block_with_attributes_test() ->
    Attrs = {attributes,
        <<"code-1"/utf8>>,
        [<<"language-gleam"/utf8>>],
        [{<<"data-executable"/utf8>>, <<"true"/utf8>>}]},
    _pipe = {code_block, Attrs, <<"fn hello() { \"Hello\" }"/utf8>>},
    snapshot(
        _pipe,
        <<"code block with id, class, and keyvalue attributes"/utf8>>
    ).

-file("test/render_block_test.gleam", 111).
-spec ordered_list_different_styles_test() -> nil.
ordered_list_different_styles_test() ->
    Roman_attrs = {list_attributes, 5, lower_roman, one_paren},
    _pipe = {ordered_list,
        Roman_attrs,
        [[{plain, [{str, <<"Five"/utf8>>}]}],
            [{plain, [{str, <<"Six"/utf8>>}]}]]},
    snapshot(_pipe, <<"ordered list starting at 5 with lower roman"/utf8>>).

-file("test/render_block_test.gleam", 120).
-spec ordered_list_upper_alpha_test() -> nil.
ordered_list_upper_alpha_test() ->
    Attrs = {list_attributes, 1, upper_alpha, two_parens},
    _pipe = {ordered_list,
        Attrs,
        [[{plain, [{str, <<"First"/utf8>>}]}],
            [{plain, [{str, <<"Second"/utf8>>}]}]]},
    snapshot(_pipe, <<"ordered list with upper alpha"/utf8>>).

-file("test/render_block_test.gleam", 129).
-spec header_default_level() -> nil.
header_default_level() ->
    _pipe = {header,
        0,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Level 0 header"/utf8>>}]},
    snapshot(_pipe, <<"header level defaults to h1"/utf8>>).
