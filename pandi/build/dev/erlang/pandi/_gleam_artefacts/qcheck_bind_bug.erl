-module(qcheck_bind_bug).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck_bind_bug.gleam").
-export([main/0]).

-file("src/qcheck_bind_bug.gleam", 6).
-spec main() -> nil.
main() ->
    Seed = qcheck:random_seed(),
    {Samples, _} = qcheck:generate(
        qcheck:generic_list(
            qcheck:generic_string(
                qcheck:lowercase_ascii_codepoint(),
                qcheck:bounded_int(1, 3)
            ),
            qcheck:bounded_int(10, 20)
        ),
        1,
        Seed
    ),
    Strings@1 = case Samples of
        [Strings] -> Strings;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"qcheck_bind_bug"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 21,
                        value => _assert_fail,
                        start => 385,
                        'end' => 415,
                        pattern_start => 396,
                        pattern_end => 405})
    end,
    Total = erlang:length(Strings@1),
    Unique = erlang:length(gleam@list:unique(Strings@1)),
    gleam_stdlib:println(
        <<"Total strings: "/utf8, (erlang:integer_to_binary(Total))/binary>>
    ),
    gleam_stdlib:println(
        <<"Unique strings: "/utf8, (erlang:integer_to_binary(Unique))/binary>>
    ),
    gleam_stdlib:println(
        <<<<"With ~17,600 possible 1-3 char strings, all should be unique, but got "/utf8,
                (erlang:integer_to_binary(Total - Unique))/binary>>/binary,
            " duplicates."/utf8>>
    ).
