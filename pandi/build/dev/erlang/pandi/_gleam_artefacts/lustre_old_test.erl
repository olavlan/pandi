-module(lustre_old_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/lustre_old_test.gleam").
-export([lustre_test/0]).
-export_type([resource/0]).

-type resource() :: {resource, binary(), binary()}.

-file("test/lustre_old_test.gleam", 16).
-spec normalize(binary()) -> binary().
normalize(Html) ->
    Re@1 = case gleam@regexp:from_string(<<"<!--[\\s\\S]*?-->"/utf8>>) of
        {ok, Re} -> Re;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_old_test"/utf8>>,
                        function => <<"normalize"/utf8>>,
                        line => 17,
                        value => _assert_fail,
                        start => 324,
                        'end' => 383,
                        pattern_start => 335,
                        pattern_end => 341})
    end,
    gleam_regexp_ffi:replace(Re@1, Html, <<""/utf8>>).

-file("test/lustre_old_test.gleam", 21).
-spec get_html_path(binary()) -> binary().
get_html_path(Json_path) ->
    gleam@string:replace(Json_path, <<"json"/utf8>>, <<"html"/utf8>>).

-file("test/lustre_old_test.gleam", 25).
-spec parse_resource(binary()) -> resource().
parse_resource(Json_path) ->
    Pandoc_json@1 = case simplifile:read(Json_path) of
        {ok, Pandoc_json} -> Pandoc_json;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_old_test"/utf8>>,
                        function => <<"parse_resource"/utf8>>,
                        line => 26,
                        value => _assert_fail,
                        start => 594,
                        'end' => 649,
                        pattern_start => 605,
                        pattern_end => 620})
    end,
    Pandoc_html@1 = case simplifile:read(get_html_path(Json_path)) of
        {ok, Pandoc_html} -> Pandoc_html;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_old_test"/utf8>>,
                        function => <<"parse_resource"/utf8>>,
                        line => 27,
                        value => _assert_fail@1,
                        start => 652,
                        'end' => 722,
                        pattern_start => 663,
                        pattern_end => 678})
    end,
    {resource, gleam@string:trim(Pandoc_html@1), Pandoc_json@1}.

-file("test/lustre_old_test.gleam", 31).
-spec read_resources() -> list(resource()).
read_resources() ->
    Files@1 = case simplifile_erl:read_directory(
        <<"test/resources/json/"/utf8>>
    ) of
        {ok, Files} -> Files;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_old_test"/utf8>>,
                        function => <<"read_resources"/utf8>>,
                        line => 32,
                        value => _assert_fail,
                        start => 818,
                        'end' => 883,
                        pattern_start => 829,
                        pattern_end => 838})
    end,
    _pipe = Files@1,
    _pipe@1 = gleam@list:map(
        _pipe,
        fun(File) -> <<"test/resources/json/"/utf8, File/binary>> end
    ),
    gleam@list:map(_pipe@1, fun parse_resource/1).

-file("test/lustre_old_test.gleam", 38).
-spec property(resource()) -> nil.
property(Resource) ->
    {resource, Pandoc_html, Pandoc_json} = Resource,
    Document@1 = case pandi:from_json(Pandoc_json) of
        {ok, Document} -> Document;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"lustre_old_test"/utf8>>,
                        function => <<"property"/utf8>>,
                        line => 40,
                        value => _assert_fail,
                        start => 1061,
                        'end' => 1115,
                        pattern_start => 1072,
                        pattern_end => 1084})
    end,
    _pipe = pandi@lustre:to_lustre(Document@1),
    _pipe@1 = lustre@element:to_string(_pipe),
    _pipe@2 = normalize(_pipe@1),
    gleeunit@should:equal(_pipe@2, Pandoc_html).

-file("test/lustre_old_test.gleam", 47).
-spec lustre_test() -> nil.
lustre_test() ->
    _pipe = read_resources(),
    gleam@list:each(_pipe, fun property/1).
