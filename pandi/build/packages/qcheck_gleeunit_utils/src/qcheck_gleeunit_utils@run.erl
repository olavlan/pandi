-module(qcheck_gleeunit_utils@run).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck_gleeunit_utils/run.gleam").
-export([run_gleeunit/0]).
-export_type([atom_/0, encoding/0, report_module_name/0, gleeunit_progress_option/0, eunit_option/0, test_repr/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module provides an alternative to the\n"
    " [gleeunit.main](https://hexdocs.pm/gleeunit/gleeunit.html#main) function\n"
    " that will run tests in parallel when targeting Erlang.  When targeting\n"
    " JavaScript, it will use Gleeunit's default runner.\n"
    "\n"
    "\n"
).

-type atom_() :: any().

-type encoding() :: utf8.

-type report_module_name() :: gleeunit_progress.

-type gleeunit_progress_option() :: {colored, boolean()}.

-type eunit_option() :: verbose |
    no_tty |
    {report, {report_module_name(), list(gleeunit_progress_option())}}.

-type test_repr() :: {inparallel, list(atom_())}.

-file("src/qcheck_gleeunit_utils/run.gleam", 77).
-spec gleam_to_erlang_module_name(binary()) -> binary().
gleam_to_erlang_module_name(Path) ->
    case gleam_stdlib:string_ends_with(Path, <<".gleam"/utf8>>) of
        true ->
            _pipe = Path,
            _pipe@1 = gleam@string:replace(
                _pipe,
                <<".gleam"/utf8>>,
                <<""/utf8>>
            ),
            gleam@string:replace(_pipe@1, <<"/"/utf8>>, <<"@"/utf8>>);

        false ->
            _pipe@2 = Path,
            _pipe@3 = gleam@string:split(_pipe@2, <<"/"/utf8>>),
            _pipe@4 = gleam@list:last(_pipe@3),
            _pipe@5 = gleam@result:unwrap(_pipe@4, Path),
            gleam@string:replace(_pipe@5, <<".erl"/utf8>>, <<""/utf8>>)
    end.

-file("src/qcheck_gleeunit_utils/run.gleam", 55).
-spec do_run_gleeunit() -> nil.
do_run_gleeunit() ->
    Options = [verbose,
        no_tty,
        {report, {gleeunit_progress, [{colored, true}]}}],
    Result = begin
        _pipe = gleeunit_ffi:find_files(
            <<"**/*.{erl,gleam}"/utf8>>,
            <<"test"/utf8>>
        ),
        _pipe@1 = gleam@list:map(_pipe, fun gleam_to_erlang_module_name/1),
        _pipe@2 = gleam@list:map(
            _pipe@1,
            fun(_capture) -> erlang:binary_to_atom(_capture, utf8) end
        ),
        _pipe@3 = {inparallel, _pipe@2},
        qcheck_gleeunit_utils_ffi:run_eunit(_pipe@3, Options)
    end,
    Code = case Result of
        {ok, _} ->
            0;

        {error, _} ->
            1
    end,
    erlang:halt(Code).

-file("src/qcheck_gleeunit_utils/run.gleam", 42).
?DOC(
    " Find and run all test functions for the current project using Erlang's EUnit\n"
    " test framework, or a custom JavaScript test runner.\n"
    "\n"
    " Any Erlang or Gleam function in the `test` directory with a name ending in\n"
    " `_test` is considered a test function and will be run.\n"
    "\n"
    " A test that panics is considered a failure.\n"
).
-spec run_gleeunit() -> nil.
run_gleeunit() ->
    do_run_gleeunit().
