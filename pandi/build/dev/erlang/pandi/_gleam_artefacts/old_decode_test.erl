-module(old_decode_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/old_decode_test.gleam").
-export([paragraph_decode_test/0, header_decode_test/0, div_decode_test/0, bullet_list_decode_test/0, code_block_decode_test/0, ordered_list_decode_test/0, link_decode_test/0, span_decode_test/0, inline_code_decode_test/0, emph_decode_test/0, strong_decode_test/0, strikeout_decode_test/0, line_break_decode_test/0, soft_break_decode_test/0]).

-file("test/old_decode_test.gleam", 6).
-spec read_resource(binary()) -> binary().
read_resource(Name) ->
    Json@1 = case simplifile:read(
        <<<<"test/resources/"/utf8, Name/binary>>/binary, ".json"/utf8>>
    ) of
        {ok, Json} -> Json;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"read_resource"/utf8>>,
                        line => 7,
                        value => _assert_fail,
                        start => 126,
                        'end' => 201,
                        pattern_start => 137,
                        pattern_end => 145})
    end,
    Json@1.

-file("test/old_decode_test.gleam", 11).
-spec paragraph_decode_test() -> nil.
paragraph_decode_test() ->
    Result = pandi:from_json(read_resource(<<"paragraph"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para, [{str, <<"Hello"/utf8>>}, space, {str, <<"world"/utf8>>}]}]
    ).

-file("test/old_decode_test.gleam", 18).
-spec header_decode_test() -> nil.
header_decode_test() ->
    Result = pandi:from_json(read_resource(<<"header"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Level@1, Attrs@1, Content@1} = case erlang:element(2, Doc) of
        [{header, Level, Attrs, Content}] -> {Level, Attrs, Content};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"header_decode_test"/utf8>>,
                        line => 21,
                        value => _assert_fail,
                        start => 553,
                        'end' => 611,
                        pattern_start => 564,
                        pattern_end => 598})
    end,
    _pipe@1 = Level@1,
    gleeunit@should:equal(_pipe@1, 1),
    _pipe@2 = erlang:element(2, Attrs@1),
    gleeunit@should:equal(_pipe@2, <<"hello-world"/utf8>>),
    _pipe@3 = Content@1,
    gleeunit@should:equal(
        _pipe@3,
        [{str, <<"Hello"/utf8>>}, space, {str, <<"world"/utf8>>}]
    ).

-file("test/old_decode_test.gleam", 27).
-spec div_decode_test() -> nil.
div_decode_test() ->
    Result = pandi:from_json(read_resource(<<"div"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Content@1} = case erlang:element(2, Doc) of
        [{'div', Attrs, Content}] -> {Attrs, Content};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"div_decode_test"/utf8>>,
                        line => 30,
                        value => _assert_fail,
                        start => 873,
                        'end' => 921,
                        pattern_start => 884,
                        pattern_end => 908})
    end,
    _pipe@1 = erlang:element(2, Attrs@1),
    gleeunit@should:equal(_pipe@1, <<"myid"/utf8>>),
    _pipe@2 = erlang:element(3, Attrs@1),
    gleeunit@should:equal(_pipe@2, [<<"mydiv"/utf8>>]),
    _pipe@3 = erlang:element(4, Attrs@1),
    gleeunit@should:equal(_pipe@3, [{<<"color"/utf8>>, <<"blue"/utf8>>}]),
    _pipe@4 = Content@1,
    gleeunit@should:equal(
        _pipe@4,
        [{para, [{str, <<"Hello"/utf8>>}, space, {str, <<"world"/utf8>>}]}]
    ).

-file("test/old_decode_test.gleam", 38).
-spec bullet_list_decode_test() -> nil.
bullet_list_decode_test() ->
    Result = pandi:from_json(read_resource(<<"bullet_list"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    Items@1 = case erlang:element(2, Doc) of
        [{bullet_list, Items}] -> Items;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"bullet_list_decode_test"/utf8>>,
                        line => 41,
                        value => _assert_fail,
                        start => 1277,
                        'end' => 1323,
                        pattern_start => 1288,
                        pattern_end => 1310})
    end,
    _pipe@1 = Items@1,
    gleeunit@should:equal(
        _pipe@1,
        [[{plain, [{str, <<"Item"/utf8>>}, space, {str, <<"1"/utf8>>}]}],
            [{plain, [{str, <<"Item"/utf8>>}, space, {str, <<"2"/utf8>>}]}],
            [{plain, [{str, <<"Item"/utf8>>}, space, {str, <<"3"/utf8>>}]}]]
    ).

-file("test/old_decode_test.gleam", 50).
-spec code_block_decode_test() -> nil.
code_block_decode_test() ->
    Result = pandi:from_json(read_resource(<<"code_block"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Text@1} = case erlang:element(2, Doc) of
        [{code_block, Attrs, Text}] -> {Attrs, Text};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"code_block_decode_test"/utf8>>,
                        line => 53,
                        value => _assert_fail,
                        start => 1662,
                        'end' => 1713,
                        pattern_start => 1673,
                        pattern_end => 1700})
    end,
    _pipe@1 = erlang:element(3, Attrs@1),
    gleeunit@should:equal(_pipe@1, [<<"python"/utf8>>]),
    _pipe@2 = Text@1,
    gleeunit@should:equal(_pipe@2, <<"print(\"hello\")"/utf8>>).

-file("test/old_decode_test.gleam", 58).
-spec ordered_list_decode_test() -> nil.
ordered_list_decode_test() ->
    Result = pandi:from_json(read_resource(<<"ordered_list"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Items@1} = case erlang:element(2, Doc) of
        [{ordered_list, Attrs, Items}] -> {Attrs, Items};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"ordered_list_decode_test"/utf8>>,
                        line => 61,
                        value => _assert_fail,
                        start => 1939,
                        'end' => 1993,
                        pattern_start => 1950,
                        pattern_end => 1980})
    end,
    _pipe@1 = erlang:element(2, Attrs@1),
    gleeunit@should:equal(_pipe@1, 1),
    _pipe@2 = erlang:element(3, Attrs@1),
    gleeunit@should:equal(_pipe@2, decimal),
    _pipe@3 = erlang:element(4, Attrs@1),
    gleeunit@should:equal(_pipe@3, period),
    _pipe@4 = Items@1,
    gleeunit@should:equal(
        _pipe@4,
        [[{plain, [{str, <<"First"/utf8>>}]}],
            [{plain, [{str, <<"Second"/utf8>>}]}],
            [{plain, [{str, <<"Third"/utf8>>}]}]]
    ).

-file("test/old_decode_test.gleam", 73).
-spec link_decode_test() -> nil.
link_decode_test() ->
    Result = pandi:from_json(read_resource(<<"link"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Content@1, Target@1} = case erlang:element(2, Doc) of
        [{para, [{link, Attrs, Content, Target}]}] -> {Attrs, Content, Target};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"link_decode_test"/utf8>>,
                        line => 76,
                        value => _assert_fail,
                        start => 2375,
                        'end' => 2443,
                        pattern_start => 2386,
                        pattern_end => 2430})
    end,
    _pipe@1 = erlang:element(2, Attrs@1),
    gleeunit@should:equal(_pipe@1, <<""/utf8>>),
    _pipe@2 = Content@1,
    gleeunit@should:equal(
        _pipe@2,
        [{str, <<"Click"/utf8>>}, space, {str, <<"here"/utf8>>}]
    ),
    _pipe@3 = erlang:element(2, Target@1),
    gleeunit@should:equal(_pipe@3, <<"https://example.com"/utf8>>),
    _pipe@4 = erlang:element(3, Target@1),
    gleeunit@should:equal(_pipe@4, <<"My Title"/utf8>>).

-file("test/old_decode_test.gleam", 83).
-spec span_decode_test() -> nil.
span_decode_test() ->
    Result = pandi:from_json(read_resource(<<"span"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Content@1} = case erlang:element(2, Doc) of
        [{para, [_, _, {span, Attrs, Content}]}] -> {Attrs, Content};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"span_decode_test"/utf8>>,
                        line => 86,
                        value => _assert_fail,
                        start => 2763,
                        'end' => 2829,
                        pattern_start => 2774,
                        pattern_end => 2816})
    end,
    _pipe@1 = erlang:element(2, Attrs@1),
    gleeunit@should:equal(_pipe@1, <<"myid"/utf8>>),
    _pipe@2 = erlang:element(3, Attrs@1),
    gleeunit@should:equal(_pipe@2, [<<"highlight"/utf8>>]),
    _pipe@3 = erlang:element(4, Attrs@1),
    gleeunit@should:equal(_pipe@3, [{<<"color"/utf8>>, <<"blue"/utf8>>}]),
    _pipe@4 = Content@1,
    gleeunit@should:equal(_pipe@4, [{str, <<"world"/utf8>>}]).

-file("test/old_decode_test.gleam", 93).
-spec inline_code_decode_test() -> nil.
inline_code_decode_test() ->
    Result = pandi:from_json(read_resource(<<"inline_code"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    {Attrs@1, Text@1} = case erlang:element(2, Doc) of
        [{para, [_, _, {code, Attrs, Text}]}] -> {Attrs, Text};
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"old_decode_test"/utf8>>,
                        function => <<"inline_code_decode_test"/utf8>>,
                        line => 96,
                        value => _assert_fail,
                        start => 3149,
                        'end' => 3212,
                        pattern_start => 3160,
                        pattern_end => 3199})
    end,
    _pipe@1 = erlang:element(3, Attrs@1),
    gleeunit@should:equal(_pipe@1, []),
    _pipe@2 = Text@1,
    gleeunit@should:equal(_pipe@2, <<"inline code"/utf8>>).

-file("test/old_decode_test.gleam", 101).
-spec emph_decode_test() -> nil.
emph_decode_test() ->
    Result = pandi:from_json(read_resource(<<"emph"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para,
                [{emph,
                        [{str, <<"emphasized"/utf8>>},
                            space,
                            {str, <<"text"/utf8>>}]}]}]
    ).

-file("test/old_decode_test.gleam", 110).
-spec strong_decode_test() -> nil.
strong_decode_test() ->
    Result = pandi:from_json(read_resource(<<"strong"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para,
                [{strong,
                        [{str, <<"strong"/utf8>>},
                            space,
                            {str, <<"text"/utf8>>}]}]}]
    ).

-file("test/old_decode_test.gleam", 119).
-spec strikeout_decode_test() -> nil.
strikeout_decode_test() ->
    Result = pandi:from_json(read_resource(<<"strikeout"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para,
                [{strikeout,
                        [{str, <<"strikeout"/utf8>>},
                            space,
                            {str, <<"text"/utf8>>}]}]}]
    ).

-file("test/old_decode_test.gleam", 128).
-spec line_break_decode_test() -> nil.
line_break_decode_test() ->
    Result = pandi:from_json(read_resource(<<"line_break"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para,
                [{str, <<"line"/utf8>>},
                    space,
                    {str, <<"one"/utf8>>},
                    line_break,
                    {str, <<"line"/utf8>>},
                    space,
                    {str, <<"two"/utf8>>}]}]
    ).

-file("test/old_decode_test.gleam", 145).
-spec soft_break_decode_test() -> nil.
soft_break_decode_test() ->
    Result = pandi:from_json(read_resource(<<"soft_break"/utf8>>)),
    Doc = begin
        _pipe = Result,
        gleeunit@should:be_ok(_pipe)
    end,
    _pipe@1 = erlang:element(2, Doc),
    gleeunit@should:equal(
        _pipe@1,
        [{para,
                [{str, <<"line"/utf8>>},
                    space,
                    {str, <<"one"/utf8>>},
                    soft_break,
                    {str, <<"line"/utf8>>},
                    space,
                    {str, <<"two"/utf8>>}]}]
    ).
