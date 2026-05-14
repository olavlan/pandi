-module(qcheck@test_error_message).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck/test_error_message.gleam").
-export([shrunk_value/1, rescue/1]).
-export_type([test_error_message/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-opaque test_error_message() :: {test_error_message,
        binary(),
        binary(),
        binary()}.

-file("src/qcheck/test_error_message.gleam", 17).
?DOC(false).
-spec shrunk_value(test_error_message()) -> binary().
shrunk_value(Msg) ->
    erlang:element(3, Msg).

-file("src/qcheck/test_error_message.gleam", 21).
?DOC(false).
-spec new_test_error_message(binary(), binary(), binary()) -> test_error_message().
new_test_error_message(Original_value, Shrunk_value, Shrink_steps) ->
    {test_error_message, Original_value, Shrunk_value, Shrink_steps}.

-file("src/qcheck/test_error_message.gleam", 33).
?DOC(false).
-spec regexp_first_submatch(binary(), binary()) -> {ok, binary()} |
    {error, binary()}.
regexp_first_submatch(Pattern, Value) ->
    _pipe = gleam@regexp:from_string(Pattern),
    _pipe@1 = gleam@result:map_error(_pipe, fun gleam@string:inspect/1),
    _pipe@2 = gleam@result:map(
        _pipe@1,
        fun(_capture) -> gleam@regexp:scan(_capture, Value) end
    ),
    _pipe@3 = gleam@result:'try'(_pipe@2, fun(Matches) -> case Matches of
                [Match] ->
                    {ok, Match};

                _ ->
                    {error,
                        <<"expected exactly one match in "/utf8, Value/binary>>}
            end end),
    gleam@result:'try'(
        _pipe@3,
        fun(Match@1) ->
            {match, _, Submatches} = Match@1,
            case Submatches of
                [{some, Submatch}] ->
                    {ok, Submatch};

                _ ->
                    {error,
                        <<"expected exactly one submatch in"/utf8,
                            Value/binary>>}
            end
        end
    ).

-file("src/qcheck/test_error_message.gleam", 62).
?DOC(false).
-spec get_original_value(binary()) -> {ok, binary()} | {error, binary()}.
get_original_value(Test_error_str) ->
    regexp_first_submatch(<<"orig.*: (.+)\n"/utf8>>, Test_error_str).

-file("src/qcheck/test_error_message.gleam", 68).
?DOC(false).
-spec get_shrunk_value(binary()) -> {ok, binary()} | {error, binary()}.
get_shrunk_value(Test_error_str) ->
    regexp_first_submatch(<<"shrnk.*: (.+)\n"/utf8>>, Test_error_str).

-file("src/qcheck/test_error_message.gleam", 74).
?DOC(false).
-spec get_shrink_steps(binary()) -> {ok, binary()} | {error, binary()}.
get_shrink_steps(Test_error_str) ->
    regexp_first_submatch(<<"steps.*: (.+)\n"/utf8>>, Test_error_str).

-file("src/qcheck/test_error_message.gleam", 85).
?DOC(false).
-spec rescue(fun(() -> ADDK)) -> {ok, ADDK} | {error, test_error_message()}.
rescue(Thunk) ->
    case qcheck_ffi:rescue_error(Thunk) of
        {ok, A} ->
            {ok, A};

        {error, Err} ->
            Test_error_message@1 = case begin
                gleam@result:'try'(
                    get_original_value(Err),
                    fun(Original_value) ->
                        gleam@result:'try'(
                            get_shrunk_value(Err),
                            fun(Shrunk_value) ->
                                gleam@result:'try'(
                                    get_shrink_steps(Err),
                                    fun(Shrink_steps) ->
                                        {ok,
                                            new_test_error_message(
                                                Original_value,
                                                Shrunk_value,
                                                Shrink_steps
                                            )}
                                    end
                                )
                            end
                        )
                    end
                )
            end of
                {ok, Test_error_message} -> Test_error_message;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"qcheck/test_error_message"/utf8>>,
                                function => <<"rescue"/utf8>>,
                                line => 90,
                                value => _assert_fail,
                                start => 2534,
                                'end' => 2934,
                                pattern_start => 2545,
                                pattern_end => 2567})
            end,
            {error, Test_error_message@1}
    end.
