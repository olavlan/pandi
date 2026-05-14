-module(to_lustre_inline_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/to_lustre_inline_test.gleam").
-export([str_test/0, space_test/0, line_break_test/0, soft_break_test/0, emph_test/0, strong_test/0, strikeout_test/0, code_test/0, code_with_attributes_test/0, span_test/0, span_with_attributes_test/0, link_test/0, link_with_title_test/0, link_with_attributes_test/0, emph_nested_test/0, strong_nested_test/0, span_with_mixed_content_test/0, link_with_emph_content_test/0]).

-file("test/to_lustre_inline_test.gleam", 6).
-spec snapshot(pandi@pandoc:inline(), binary()) -> nil.
snapshot(Inline, Title) ->
    _pipe = pandi@lustre:inline_to_lustre(Inline),
    _pipe@1 = lustre@element:to_readable_string(_pipe),
    birdie:snap(_pipe@1, <<"[to_lustre_inline] "/utf8, Title/binary>>).

-file("test/to_lustre_inline_test.gleam", 12).
-spec str_test() -> nil.
str_test() ->
    _pipe = {str, <<"Hello"/utf8>>},
    snapshot(_pipe, <<"simple string"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 17).
-spec space_test() -> nil.
space_test() ->
    _pipe = space,
    snapshot(_pipe, <<"space"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 22).
-spec line_break_test() -> nil.
line_break_test() ->
    _pipe = line_break,
    snapshot(_pipe, <<"line break"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 27).
-spec soft_break_test() -> nil.
soft_break_test() ->
    _pipe = soft_break,
    snapshot(_pipe, <<"soft break"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 32).
-spec emph_test() -> nil.
emph_test() ->
    _pipe = {emph, [{str, <<"Emphasized"/utf8>>}]},
    snapshot(_pipe, <<"emphasis with simple text"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 37).
-spec strong_test() -> nil.
strong_test() ->
    _pipe = {strong, [{str, <<"Bold"/utf8>>}]},
    snapshot(_pipe, <<"strong with simple text"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 42).
-spec strikeout_test() -> nil.
strikeout_test() ->
    _pipe = {strikeout, [{str, <<"Deleted"/utf8>>}]},
    snapshot(_pipe, <<"strikeout with simple text"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 47).
-spec code_test() -> nil.
code_test() ->
    _pipe = {code, {attributes, <<""/utf8>>, [], []}, <<"let x = 1"/utf8>>},
    snapshot(_pipe, <<"inline code without attributes"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 52).
-spec code_with_attributes_test() -> nil.
code_with_attributes_test() ->
    Attrs = {attributes,
        <<"code-1"/utf8>>,
        [<<"language-gleam"/utf8>>],
        [{<<"data-executable"/utf8>>, <<"true"/utf8>>}]},
    _pipe = {code, Attrs, <<"fn hello() { \"Hello\" }"/utf8>>},
    snapshot(
        _pipe,
        <<"inline code with id, class, and keyvalue attributes"/utf8>>
    ).

-file("test/to_lustre_inline_test.gleam", 59).
-spec span_test() -> nil.
span_test() ->
    _pipe = {span,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Span content"/utf8>>}]},
    snapshot(_pipe, <<"span without attributes"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 64).
-spec span_with_attributes_test() -> nil.
span_with_attributes_test() ->
    Attrs = {attributes,
        <<"my-span"/utf8>>,
        [<<"highlight"/utf8>>],
        [{<<"data-role"/utf8>>, <<"note"/utf8>>}]},
    _pipe = {span, Attrs, [{str, <<"Styled span"/utf8>>}]},
    snapshot(_pipe, <<"span with id, classes, and keyvalue attributes"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 71).
-spec link_test() -> nil.
link_test() ->
    Target = {target, <<"https://example.com"/utf8>>, <<""/utf8>>},
    _pipe = {link,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Click here"/utf8>>}],
        Target},
    snapshot(_pipe, <<"link without title"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 77).
-spec link_with_title_test() -> nil.
link_with_title_test() ->
    Target = {target, <<"https://example.com"/utf8>>, <<"Example Site"/utf8>>},
    _pipe = {link,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Click here"/utf8>>}],
        Target},
    snapshot(_pipe, <<"link with title"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 83).
-spec link_with_attributes_test() -> nil.
link_with_attributes_test() ->
    Attrs = {attributes,
        <<"link-1"/utf8>>,
        [<<"external"/utf8>>],
        [{<<"data-track"/utf8>>, <<"true"/utf8>>}]},
    Target = {target, <<"https://example.com"/utf8>>, <<"Example"/utf8>>},
    _pipe = {link, Attrs, [{str, <<"Attributed link"/utf8>>}], Target},
    snapshot(_pipe, <<"link with id, classes, and keyvalue attributes"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 90).
-spec emph_nested_test() -> nil.
emph_nested_test() ->
    _pipe = {emph,
        [{str, <<"Very "/utf8>>}, {strong, [{str, <<"important"/utf8>>}]}]},
    snapshot(_pipe, <<"emphasis with nested strong"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 98).
-spec strong_nested_test() -> nil.
strong_nested_test() ->
    _pipe = {strong, [{emph, [{str, <<"Bold and italic"/utf8>>}]}]},
    snapshot(_pipe, <<"strong with nested emphasis"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 105).
-spec span_with_mixed_content_test() -> nil.
span_with_mixed_content_test() ->
    _pipe = {span,
        {attributes, <<""/utf8>>, [], []},
        [{str, <<"Text "/utf8>>},
            {emph, [{str, <<"emphasized"/utf8>>}]},
            space,
            {strong, [{str, <<"bold"/utf8>>}]}]},
    snapshot(_pipe, <<"span with mixed inline content"/utf8>>).

-file("test/to_lustre_inline_test.gleam", 115).
-spec link_with_emph_content_test() -> nil.
link_with_emph_content_test() ->
    Target = {target, <<"https://example.com"/utf8>>, <<""/utf8>>},
    _pipe = {link,
        {attributes, <<""/utf8>>, [], []},
        [{emph, [{str, <<"Emphasized link text"/utf8>>}]}],
        Target},
    snapshot(_pipe, <<"link with emphasized content"/utf8>>).
