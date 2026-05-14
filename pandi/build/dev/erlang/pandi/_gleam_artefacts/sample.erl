-module(sample).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/sample.gleam").
-export([main/0]).

-file("src/sample.gleam", 6).
-spec main() -> nil.
main() ->
    Seed = qcheck:random_seed(),
    {Docs, _} = qcheck:generate(pandi@generator:document_generator(), 1, Seed),
    Doc@1 = case Docs of
        [Doc] -> Doc;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"sample"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 9,
                        value => _assert_fail,
                        start => 195,
                        'end' => 218,
                        pattern_start => 206,
                        pattern_end => 211})
    end,
    _pipe = Doc@1,
    _pipe@1 = pandi:to_json(_pipe),
    gleam_stdlib:println(_pipe@1).
