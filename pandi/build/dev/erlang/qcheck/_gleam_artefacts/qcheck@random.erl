-module(qcheck@random).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/qcheck/random.gleam").
-export([seed/1, int/2, random_seed/0, step/2, float/2, float_weighted/2, weighted/2, uniform/2, choose/2, bind/2, then/2, map/2, to_yielder/2, to_random_yielder/1, sample/2, random_sample/1, constant/1]).
-export_type([seed/0, generator/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Random\n"
    "\n"
    " The random module provides basic random value generators that can be used\n"
    " to define Generators.\n"
    "\n"
    " They are mostly inteded for internal use or \"advanced\" manual construction\n"
    " of generators.  In typical usage, you will probably not need to interact\n"
    " with these functions much, if at all.  As such, they are currently mostly\n"
    " undocumented.\n"
    "\n"
).

-opaque seed() :: {seed, prng@random:seed()}.

-opaque generator(RDI) :: {generator, prng@random:generator(RDI)}.

-file("src/qcheck/random.gleam", 39).
?DOC(
    " `seed(n) creates a new seed from the given integer, `n`.\n"
    "\n"
    " ### Example\n"
    "\n"
    " Use a specific seed for the `Config`.\n"
    "\n"
    " ```\n"
    " let config =\n"
    "   qcheck.default_config()\n"
    "   |> qcheck.with_seed(qcheck.seed(124))\n"
    " ```\n"
).
-spec seed(integer()) -> seed().
seed(N) ->
    _pipe = prng_ffi:new_seed(N),
    {seed, _pipe}.

-file("src/qcheck/random.gleam", 77).
-spec int(integer(), integer()) -> generator(integer()).
int(From, To) ->
    _pipe = prng@random:int(From, To),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 56).
?DOC(
    " `random_seed()` creates a new randomly-generated seed.  You can use it when\n"
    " you don't care about having specifically reproducible results.\n"
    "\n"
    " ### Example\n"
    "\n"
    " Use a random seed for the `Config`.\n"
    "\n"
    " ```\n"
    " let config =\n"
    "   qcheck.default_config()\n"
    "   |> qcheck.with_seed(qcheck.random_seed())\n"
    " ```\n"
).
-spec random_seed() -> seed().
random_seed() ->
    _pipe = gleam@int:random(4294967296),
    _pipe@1 = prng_ffi:new_seed(_pipe),
    {seed, _pipe@1}.

-file("src/qcheck/random.gleam", 72).
-spec step(generator(RDJ), seed()) -> {RDJ, seed()}.
step(Generator, Seed) ->
    {A, Seed@1} = prng@random:step(
        erlang:element(2, Generator),
        erlang:element(2, Seed)
    ),
    {A, {seed, Seed@1}}.

-file("src/qcheck/random.gleam", 81).
-spec float(float(), float()) -> generator(float()).
float(From, To) ->
    _pipe = prng@random:float(From, To),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 89).
?DOC(
    " Like `weighted` but uses `Floats` to specify the weights.\n"
    "\n"
    " Generally you should prefer `weighted` as it is faster.\n"
).
-spec float_weighted({float(), RDN}, list({float(), RDN})) -> generator(RDN).
float_weighted(First, Others) ->
    _pipe = prng@random:weighted(First, Others),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 112).
-spec get_by_weight({integer(), RDY}, list({integer(), RDY}), integer()) -> RDY.
get_by_weight(First, Others, Countdown) ->
    {Weight, Value} = First,
    case Others of
        [] ->
            Value;

        [Second | Rest] ->
            Positive_weight = gleam@int:absolute_value(Weight),
            case gleam@int:compare(Countdown, Positive_weight) of
                lt ->
                    Value;

                gt ->
                    get_by_weight(Second, Rest, Countdown - Positive_weight);

                eq ->
                    get_by_weight(Second, Rest, Countdown - Positive_weight)
            end
    end.

-file("src/qcheck/random.gleam", 96).
-spec weighted({integer(), RDQ}, list({integer(), RDQ})) -> generator(RDQ).
weighted(First, Others) ->
    Normalise = fun(Pair) ->
        gleam@int:absolute_value(gleam@pair:first(Pair))
    end,
    Total = Normalise(First) + gleam@int:sum(gleam@list:map(Others, Normalise)),
    _pipe = prng@random:map(
        prng@random:int(0, Total - 1),
        fun(_capture) -> get_by_weight(First, Others, _capture) end
    ),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 104).
-spec uniform(RDT, list(RDT)) -> generator(RDT).
uniform(First, Others) ->
    weighted(
        {1, First},
        gleam@list:map(Others, fun(_capture) -> gleam@pair:new(1, _capture) end)
    ).

-file("src/qcheck/random.gleam", 108).
-spec choose(RDW, RDW) -> generator(RDW).
choose(One, Other) ->
    uniform(One, [Other]).

-file("src/qcheck/random.gleam", 126).
-spec bind(generator(REA), fun((REA) -> generator(REC))) -> generator(REC).
bind(Generator, F) ->
    _pipe = prng@random:then(
        erlang:element(2, Generator),
        fun(A) ->
            Generator@1 = F(A),
            erlang:element(2, Generator@1)
        end
    ),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 138).
?DOC(" `then` is an alias for `bind`.\n").
-spec then(generator(REF), fun((REF) -> generator(REH))) -> generator(REH).
then(Generator, F) ->
    bind(Generator, F).

-file("src/qcheck/random.gleam", 142).
-spec map(generator(REK), fun((REK) -> REM)) -> generator(REM).
map(Generator, Fun) ->
    _pipe = prng@random:map(erlang:element(2, Generator), Fun),
    {generator, _pipe}.

-file("src/qcheck/random.gleam", 150).
-spec to_yielder(generator(RER), seed()) -> gleam@yielder:yielder(RER).
to_yielder(Generator, Seed) ->
    gleam@yielder:unfold(
        Seed,
        fun(Current_seed) ->
            {Value, Next_seed} = step(Generator, Current_seed),
            {next, Value, Next_seed}
        end
    ).

-file("src/qcheck/random.gleam", 146).
-spec to_random_yielder(generator(REO)) -> gleam@yielder:yielder(REO).
to_random_yielder(Generator) ->
    to_yielder(Generator, random_seed()).

-file("src/qcheck/random.gleam", 161).
-spec sample(generator(REW), seed()) -> REW.
sample(Generator, Seed) ->
    {Value, _} = step(Generator, Seed),
    Value.

-file("src/qcheck/random.gleam", 157).
-spec random_sample(generator(REU)) -> REU.
random_sample(Generator) ->
    sample(Generator, random_seed()).

-file("src/qcheck/random.gleam", 166).
-spec constant(REY) -> generator(REY).
constant(Value) ->
    _pipe = prng@random:constant(Value),
    {generator, _pipe}.
