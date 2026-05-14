-module(decode_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/decode_test.gleam").
-export([paragraph_test/0, bullet_list_test/0, code_block_test/0, div_test/0, emph_test/0, header_test/0, inline_code_test/0, line_break_test/0, link_test/0, ordered_list_test/0, soft_break_test/0, span_test/0, strikeout_test/0, strong_test/0]).
-export_type([test_resource/0]).

-type test_resource() :: {test_resource, binary(), binary()}.

-file("test/decode_test.gleam", 11).
-spec read_resource(binary()) -> test_resource().
read_resource(Name) ->
    Markdown@1 = case simplifile:read(
        <<<<"test/resources/md/"/utf8, Name/binary>>/binary, ".md"/utf8>>
    ) of
        {ok, Markdown} -> Markdown;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"decode_test"/utf8>>,
                        function => <<"read_resource"/utf8>>,
                        line => 12,
                        value => _assert_fail,
                        start => 210,
                        'end' => 294,
                        pattern_start => 221,
                        pattern_end => 233})
    end,
    Json@1 = case simplifile:read(
        <<<<"test/resources/json/"/utf8, Name/binary>>/binary, ".json"/utf8>>
    ) of
        {ok, Json} -> Json;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"decode_test"/utf8>>,
                        function => <<"read_resource"/utf8>>,
                        line => 14,
                        value => _assert_fail@1,
                        start => 297,
                        'end' => 381,
                        pattern_start => 308,
                        pattern_end => 316})
    end,
    {test_resource, Markdown@1, Json@1}.

-file("test/decode_test.gleam", 19).
-spec snapshot(binary()) -> nil.
snapshot(Resource_name) ->
    {test_resource, _, Json} = read_resource(Resource_name),
    _pipe = pandi:from_json(Json),
    _pipe@1 = gleeunit@should:be_ok(_pipe),
    _pipe@2 = gleam@string:inspect(_pipe@1),
    birdie:snap(_pipe@2, <<"[from_json] "/utf8, Resource_name/binary>>).

-file("test/decode_test.gleam", 27).
-spec paragraph_test() -> nil.
paragraph_test() ->
    snapshot(<<"paragraph"/utf8>>).

-file("test/decode_test.gleam", 31).
-spec bullet_list_test() -> nil.
bullet_list_test() ->
    snapshot(<<"bullet_list"/utf8>>).

-file("test/decode_test.gleam", 35).
-spec code_block_test() -> nil.
code_block_test() ->
    snapshot(<<"code_block"/utf8>>).

-file("test/decode_test.gleam", 39).
-spec div_test() -> nil.
div_test() ->
    snapshot(<<"div"/utf8>>).

-file("test/decode_test.gleam", 43).
-spec emph_test() -> nil.
emph_test() ->
    snapshot(<<"emph"/utf8>>).

-file("test/decode_test.gleam", 47).
-spec header_test() -> nil.
header_test() ->
    snapshot(<<"header"/utf8>>).

-file("test/decode_test.gleam", 51).
-spec inline_code_test() -> nil.
inline_code_test() ->
    snapshot(<<"inline_code"/utf8>>).

-file("test/decode_test.gleam", 55).
-spec line_break_test() -> nil.
line_break_test() ->
    snapshot(<<"line_break"/utf8>>).

-file("test/decode_test.gleam", 59).
-spec link_test() -> nil.
link_test() ->
    snapshot(<<"link"/utf8>>).

-file("test/decode_test.gleam", 63).
-spec ordered_list_test() -> nil.
ordered_list_test() ->
    snapshot(<<"ordered_list"/utf8>>).

-file("test/decode_test.gleam", 67).
-spec soft_break_test() -> nil.
soft_break_test() ->
    snapshot(<<"soft_break"/utf8>>).

-file("test/decode_test.gleam", 71).
-spec span_test() -> nil.
span_test() ->
    snapshot(<<"span"/utf8>>).

-file("test/decode_test.gleam", 75).
-spec strikeout_test() -> nil.
strikeout_test() ->
    snapshot(<<"strikeout"/utf8>>).

-file("test/decode_test.gleam", 79).
-spec strong_test() -> nil.
strong_test() ->
    snapshot(<<"strong"/utf8>>).
