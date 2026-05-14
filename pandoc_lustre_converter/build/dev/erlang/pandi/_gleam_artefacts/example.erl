-module(example).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/example.gleam").
-export([main/0]).

-file("src/example.gleam", 8).
-spec main() -> nil.
main() ->
    Json_input@1 = case in:read_chars(1000000) of
        {ok, Json_input} -> Json_input;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"example"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 9,
                        value => _assert_fail,
                        start => 156,
                        'end' => 208,
                        pattern_start => 167,
                        pattern_end => 181})
    end,
    Document@1 = case pandi:from_json(Json_input@1) of
        {ok, Document} -> Document;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"example"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 11,
                        value => _assert_fail@1,
                        start => 212,
                        'end' => 265,
                        pattern_start => 223,
                        pattern_end => 235})
    end,
    Increase_header_level = fun(Block, _) -> case Block of
            {header, Level, Attrs, Content} ->
                {some, [{header, Level + 1, Attrs, Content}]};

            _ ->
                none
        end end,
    _pipe = Document@1,
    _pipe@1 = pandi@filter:filter_blocks(_pipe, Increase_header_level),
    _pipe@2 = pandi:to_json(_pipe@1),
    gleam_stdlib:println(_pipe@2).
