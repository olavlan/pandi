-module(qcheck_gleeunit_utils@test_spec).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck_gleeunit_utils/test_spec.gleam").
-export([make/1, make_with_timeout/2, run_in_parallel/1, run_in_order/1]).
-export_type([test_spec/1, test_group/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Utility functions for representing tests and test groups in Gleeunit, \n"
    " allowing users to control the timeout length of individual tests as well as \n"
    " to create groups of tests that will be run in parallel or in order.\n"
    " \n"
    " - [TestSpec](#TestSpec) values are created by [make](#make) and \n"
    "   [make_with_timeout](#make_with_timeout).\n"
    " - [TestGroup](#TestGroup) values are created by \n"
    "   [run_in_parallel](#run_in_parallel) and [run_in_order](#run_in_order).\n"
    "\n"
    " Both `TestSpec`s and `TestGroup`s represent tests as data, which, when \n"
    " targeting Erlang, will be executed by the test runner *if* they are \n"
    " returned by a test generating function (that is, a function whose name is \n"
    " prefixed by `_test_`).\n"
    " \n"
    " **Note:** The functions in this module will *NOT* work correclty on the \n"
    " JavaScript target.\n"
    " \n"
    " \n"
).

-opaque test_spec(SXG) :: {timeout, integer(), fun(() -> SXG)}.

-opaque test_group(SXH) :: {inparallel, list(test_spec(SXH))} |
    {inorder, list(test_spec(SXH))}.

-file("src/qcheck_gleeunit_utils/test_spec.gleam", 67).
?DOC(
    " `make(f)` creates a test specification that specifies how to run the\n"
    " function `f` with a very long timeout.\n"
    " \n"
    " While the function `f` can technically return a value of any type, it is\n"
    " likely that the return type will be `Nil`.  For example, when using \n"
    " functions from the `gleeunit/should` module.\n"
    " \n"
    " ```gleam\n"
    " make(fn() {\n"
    "   should.equal(1 + 2, 3)\n"
    " })\n"
    " ```\n"
    " \n"
    " You may prefer the `use` syntax:\n"
    " \n"
    " ```gleam\n"
    " use <- make\n"
    " should.equal(1 + 2, 3)\n"
    " ```\n"
    " \n"
    " Named functions of the correct signature may also be used.\n"
    " \n"
    " ```gleam\n"
    " fn addition_is_commutative() {\n"
    "   should.equal(1 + 2, 2 + 1)\n"
    " }\n"
    " \n"
    " // ... later inside some other function ...\n"
    " make(addition_is_commutative)\n"
    " ```\n"
).
-spec make(fun(() -> SXI)) -> test_spec(SXI).
make(F) ->
    {timeout, 2147483647, F}.

-file("src/qcheck_gleeunit_utils/test_spec.gleam", 77).
?DOC(
    " `make_with_timeout(timeout, f)` creates a test specification that specifies\n"
    " how to run the function `f` with a custom `timeout` in given in seconds.\n"
    " \n"
    " See [make](#make) for examples.\n"
).
-spec make_with_timeout(integer(), fun(() -> SXK)) -> test_spec(SXK).
make_with_timeout(Timeout, F) ->
    {timeout, Timeout, F}.

-file("src/qcheck_gleeunit_utils/test_spec.gleam", 109).
?DOC(
    " `run_in_parallel(test_specs)` creates a test group that specifies that the\n"
    " given `test_specs` should be run in parallel.\n"
    " \n"
    " The `run_in_parallel` function is generally used in the context of a \n"
    " [test generating function](https://www.erlang.org/doc/apps/eunit/chapter#writing-test-generating-functions).\n"
    " You write a function that returns a representation of the set of tests to be\n"
    " executed.  \n"
    " \n"
    " The names of these functions **must** end with `_test_` (note the trailing \n"
    " underscore).\n"
    " \n"
    " ```gleam\n"
    " pub fn a_lengthy_nice_math_test_() {\n"
    "   [\n"
    "     make(fn() {\n"
    "       let result = some_lengthy_calculation(1, 2)\n"
    "       should.equal(1, result)\n"
    "     }),\n"
    "     make(fn() {\n"
    "       let result = another_lengthy_calculation(10, 20)\n"
    "       should.equal(100, result)\n"
    "     }),\n"
    "   ]\n"
    "   |> run_in_parallel\n"
    " }\n"
    " ```\n"
).
-spec run_in_parallel(list(test_spec(SXM))) -> test_group(SXM).
run_in_parallel(Test_specs) ->
    {inparallel, Test_specs}.

-file("src/qcheck_gleeunit_utils/test_spec.gleam", 119).
?DOC(
    " `run_in_order(test_specs)` creates a test group that specifies that the\n"
    " given `test_specs` should be run in order.\n"
    " \n"
    " See `run_in_parallel` for examples.\n"
).
-spec run_in_order(list(test_spec(SXQ))) -> test_group(SXQ).
run_in_order(Test_specs) ->
    {inorder, Test_specs}.
