-module(qcheck@internal@reporting).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck/internal/reporting.gleam").
-export([test_failed_message/4]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/qcheck/internal/reporting.gleam", 31).
?DOC(false).
-spec format_unknown(gleam@dynamic:dynamic_()) -> binary().
format_unknown(Error) ->
    erlang:list_to_binary(
        [<<"An unexpected error occurred:\n"/utf8>>,
            <<"\n"/utf8>>,
            <<<<"  "/utf8, (gleam@string:inspect(Error))/binary>>/binary,
                "\n"/utf8>>]
    ).

-file("src/qcheck/internal/reporting.gleam", 142).
?DOC(false).
-spec bold(binary()) -> binary().
bold(Text) ->
    <<<<"\x{001b}[1m"/utf8, Text/binary>>/binary, "\x{001b}[22m"/utf8>>.

-file("src/qcheck/internal/reporting.gleam", 146).
?DOC(false).
-spec cyan(binary()) -> binary().
cyan(Text) ->
    <<<<"\x{001b}[36m"/utf8, Text/binary>>/binary, "\x{001b}[39m"/utf8>>.

-file("src/qcheck/internal/reporting.gleam", 131).
?DOC(false).
-spec code_snippet(gleam@option:option(bitstring()), integer(), integer()) -> binary().
code_snippet(Src, Start, End) ->
    _pipe = begin
        gleam@result:'try'(
            gleam@option:to_result(Src, nil),
            fun(Src@1) ->
                gleam@result:'try'(
                    gleam_stdlib:bit_array_slice(Src@1, Start, End - Start),
                    fun(Snippet) ->
                        gleam@result:'try'(
                            gleam@bit_array:to_string(Snippet),
                            fun(Snippet@1) ->
                                Snippet@2 = <<<<<<(cyan(<<" code"/utf8>>))/binary,
                                            ": "/utf8>>/binary,
                                        Snippet@1/binary>>/binary,
                                    "\n"/utf8>>,
                                {ok, Snippet@2}
                            end
                        )
                    end
                )
            end
        )
    end,
    gleam@result:unwrap(_pipe, <<""/utf8>>).

-file("src/qcheck/internal/reporting.gleam", 150).
?DOC(false).
-spec yellow(binary()) -> binary().
yellow(Text) ->
    <<<<"\x{001b}[33m"/utf8, Text/binary>>/binary, "\x{001b}[39m"/utf8>>.

-file("src/qcheck/internal/reporting.gleam", 154).
?DOC(false).
-spec grey(binary()) -> binary().
grey(Text) ->
    <<<<"\x{001b}[90m"/utf8, Text/binary>>/binary, "\x{001b}[39m"/utf8>>.

-file("src/qcheck/internal/reporting.gleam", 123).
?DOC(false).
-spec inspect_value(qcheck@internal@gleam_panic:asserted_expression()) -> binary().
inspect_value(Value) ->
    case erlang:element(4, Value) of
        unevaluated ->
            grey(<<"unevaluated"/utf8>>);

        {literal, _} ->
            grey(<<"literal"/utf8>>);

        {expression, Value@1} ->
            gleam@string:inspect(Value@1)
    end.

-file("src/qcheck/internal/reporting.gleam", 119).
?DOC(false).
-spec assert_value(binary(), qcheck@internal@gleam_panic:asserted_expression()) -> binary().
assert_value(Name, Value) ->
    <<<<<<(cyan(Name))/binary, ": "/utf8>>/binary,
            (inspect_value(Value))/binary>>/binary,
        "\n"/utf8>>.

-file("src/qcheck/internal/reporting.gleam", 97).
?DOC(false).
-spec assert_info(qcheck@internal@gleam_panic:assert_kind()) -> binary().
assert_info(Kind) ->
    case Kind of
        {binary_operator, _, Left, Right} ->
            erlang:list_to_binary(
                [assert_value(<<" left"/utf8>>, Left),
                    assert_value(<<"right"/utf8>>, Right)]
            );

        {function_call, Arguments} ->
            _pipe = Arguments,
            _pipe@1 = gleam@list:index_map(
                _pipe,
                fun(E, I) ->
                    Number = gleam@string:pad_start(
                        erlang:integer_to_binary(I),
                        5,
                        <<" "/utf8>>
                    ),
                    assert_value(Number, E)
                end
            ),
            erlang:list_to_binary(_pipe@1);

        {other_expression, _} ->
            <<""/utf8>>
    end.

-file("src/qcheck/internal/reporting.gleam", 39).
?DOC(false).
-spec format_gleam_error(
    qcheck@internal@gleam_panic:gleam_panic(),
    gleam@option:option(bitstring()),
    LSW,
    LSW,
    integer()
) -> binary().
format_gleam_error(Error, Src, Original_value, Shrunk_value, Shrink_steps) ->
    Location = grey(
        <<<<(erlang:element(3, Error))/binary, ":"/utf8>>/binary,
            (erlang:integer_to_binary(erlang:element(6, Error)))/binary>>
    ),
    Panic_info = case erlang:element(7, Error) of
        panic ->
            [<<<<<<(bold(yellow(<<"\nqcheck panic"/utf8>>)))/binary, " "/utf8>>/binary,
                        Location/binary>>/binary,
                    "\n"/utf8>>,
                <<<<<<(cyan(<<" info"/utf8>>))/binary, ": "/utf8>>/binary,
                        (erlang:element(2, Error))/binary>>/binary,
                    "\n"/utf8>>];

        todo ->
            [<<<<<<(bold(yellow(<<"\nqcheck todo"/utf8>>)))/binary, " "/utf8>>/binary,
                        Location/binary>>/binary,
                    "\n"/utf8>>,
                <<<<<<(cyan(<<" info"/utf8>>))/binary, ": "/utf8>>/binary,
                        (erlang:element(2, Error))/binary>>/binary,
                    "\n"/utf8>>];

        {assert, Start, End, _, Kind} ->
            [<<<<<<(bold(yellow(<<"\nqcheck assert"/utf8>>)))/binary, " "/utf8>>/binary,
                        Location/binary>>/binary,
                    "\n"/utf8>>,
                code_snippet(Src, Start, End),
                assert_info(Kind),
                <<<<<<(cyan(<<" info"/utf8>>))/binary, ": "/utf8>>/binary,
                        (erlang:element(2, Error))/binary>>/binary,
                    "\n"/utf8>>];

        {let_assert, Start@1, End@1, _, _, Value} ->
            [<<<<<<(bold(yellow(<<"\nqcheck let assert"/utf8>>)))/binary,
                            " "/utf8>>/binary,
                        Location/binary>>/binary,
                    "\n"/utf8>>,
                code_snippet(Src, Start@1, End@1),
                <<<<<<(cyan(<<"value"/utf8>>))/binary, ": "/utf8>>/binary,
                        (gleam@string:inspect(Value))/binary>>/binary,
                    "\n"/utf8>>,
                <<<<<<(cyan(<<" info"/utf8>>))/binary, ": "/utf8>>/binary,
                        (erlang:element(2, Error))/binary>>/binary,
                    "\n"/utf8>>]
    end,
    Shrink_info = [bold(yellow(<<"qcheck shrinks\n"/utf8>>)),
        <<<<<<(cyan(<<" orig"/utf8>>))/binary, ": "/utf8>>/binary,
                (gleam@string:inspect(Original_value))/binary>>/binary,
            "\n"/utf8>>,
        <<<<<<(cyan(<<"shrnk"/utf8>>))/binary, ": "/utf8>>/binary,
                (gleam@string:inspect(Shrunk_value))/binary>>/binary,
            "\n"/utf8>>,
        <<<<<<(cyan(<<"steps"/utf8>>))/binary, ": "/utf8>>/binary,
                (erlang:integer_to_binary(Shrink_steps))/binary>>/binary,
            "\n"/utf8>>],
    _pipe = lists:append(
        [[<<"a property was falsified!"/utf8>>], Panic_info, Shrink_info]
    ),
    erlang:list_to_binary(_pipe).

-file("src/qcheck/internal/reporting.gleam", 10).
?DOC(false).
-spec test_failed_message(gleam@dynamic:dynamic_(), LSU, LSU, integer()) -> binary().
test_failed_message(Error, Original_value, Shrunk_value, Shrink_steps) ->
    case gleeunit_gleam_panic_ffi:from_dynamic(Error) of
        {ok, Error@1} ->
            Src = gleam@option:from_result(
                file:read_file(erlang:element(3, Error@1))
            ),
            format_gleam_error(
                Error@1,
                Src,
                Original_value,
                Shrunk_value,
                Shrink_steps
            );

        {error, _} ->
            format_unknown(Error)
    end.
