-module(prng@random).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/prng/random.gleam").
-export([new_seed/1, step/2, int/2, float/2, constant/1, fixed_size_list/2, then/2, list/1, map/2, weighted/2, uniform/2, try_uniform/1, try_weighted/1, choose/2, pair/2, dict/2, fixed_size_dict/3, set/1, fixed_size_set/2, fixed_size_string/1, string/0, bit_array/0, shuffle/1, sample/2, map2/3, map3/4, map4/5, map5/6]).
-export_type([generator/1, seed/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This package provides many building blocks that can be used to define\n"
    " pure generators of pseudo-random values.\n"
    "\n"
    " This is based on the great\n"
    " [Elm implementation](https://package.elm-lang.org/packages/elm/random/1.0.0/)\n"
    " of [Permuted Congruential Generators](https://www.pcg-random.org).\n"
    "\n"
    " _It is not cryptographically secure!_\n"
    "\n"
    " You can use this cheatsheet to navigate the module documentation:\n"
    "\n"
    " <table>\n"
    " <tr>\n"
    "   <td>Building generators</td>\n"
    "   <td>\n"
    "     <a href=\"#int\">int</a>,\n"
    "     <a href=\"#float\">float</a>,\n"
    "     <a href=\"#string\">string</a>,\n"
    "     <a href=\"#fixed_size_string\">fixed_size_string</a>,\n"
    "     <a href=\"#bit_array\">bit_array</a>,\n"
    "     <a href=\"#uniform\">uniform</a>,\n"
    "     <a href=\"#weighted\">weighted</a>,\n"
    "     <a href=\"#choose\">choose</a>,\n"
    "     <a href=\"#constant\">constant</a>\n"
    "   </td>\n"
    " </tr>\n"
    " <tr>\n"
    "   <td>Transform and compose generators</td>\n"
    "   <td>\n"
    "     <a href=\"#map\">map</a>,\n"
    "     <a href=\"#then\">then</a>\n"
    "   </td>\n"
    " </tr>\n"
    " <tr>\n"
    "   <td>Generating common data structures</td>\n"
    "   <td>\n"
    "     <a href=\"#fixed_size_list\">fixed_size_list</a>,\n"
    "     <a href=\"#list\">list</a>,\n"
    "     <a href=\"#fixed_size_dict\">fixed_size_dict</a>,\n"
    "     <a href=\"#dict\">dict</a>\n"
    "     <a href=\"#fixed_size_set\">fixed_size_set</a>,\n"
    "     <a href=\"#set\">set</a>\n"
    "   </td>\n"
    " </tr>\n"
    " <tr>\n"
    "   <td>Getting values out of a generator</td>\n"
    "   <td>\n"
    "     <a href=\"#step\">step</a>\n"
    "   </td>\n"
    " </tr>\n"
    " </table>\n"
    "\n"
).

-opaque generator(AAUR) :: {generator, fun((seed()) -> {AAUR, seed()})}.

-type seed() :: any().

-file("src/prng/random.gleam", 120).
-spec new_seed(integer()) -> seed().
new_seed(Int) ->
    prng_ffi:new_seed(Int).

-file("src/prng/random.gleam", 149).
?DOC(
    " Steps a `Generator(a)` producing a random value of type `a` using the given\n"
    " seed as the source of randomness.\n"
    "\n"
    " The stepping logic is completely deterministic. This means that, given a\n"
    " seed and a generator, you'll always get the same result.\n"
    "\n"
    " This is why this function also returns a new seed that can be used to make\n"
    " subsequent calls to `step` to get other random values.\n"
    "\n"
    " Stepping a generator by hand can be quite cumbersome, so I recommend you\n"
    " try [`to_yielder`](#to_yielder),\n"
    " [`to_random_yielder`](#to_random_yielder), or [`sample`](#sample) instead.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let initial_seed = seed.new(11)\n"
    " let dice_roll = random.int(1, 6)\n"
    " let #(first_roll, new_seed) = random.step(dice_roll, initial_seed)\n"
    " let #(second_roll, _) = random.step(dice_roll, new_seed)\n"
    "\n"
    " #(first_roll, second_roll)\n"
    " // -> #(3, 2)\n"
    " ```\n"
).
-spec step(generator(AAUS), seed()) -> {AAUS, seed()}.
step(Generator, Seed) ->
    (erlang:element(2, Generator))(Seed).

-file("src/prng/random.gleam", 179).
?DOC(
    " Generates integers in the given inclusive range.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Say you want to model the outcome of a dice, you could use `int` like this:\n"
    "\n"
    " ```gleam\n"
    " let dice_roll = random.int(1, 6)\n"
    " ```\n"
).
-spec int(integer(), integer()) -> generator(integer()).
int(From, To) ->
    case From =< To of
        true ->
            {generator,
                fun(_capture) -> prng_ffi:random_int(_capture, From, To) end};

        false ->
            {generator,
                fun(_capture@1) -> prng_ffi:random_int(_capture@1, To, From) end}
    end.

-file("src/prng/random.gleam", 198).
?DOC(
    " Generates floating point numbers in the given inclusive range.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let probability = random.float(0.0, 1.0)\n"
    " ```\n"
).
-spec float(float(), float()) -> generator(float()).
float(From, To) ->
    case From =< To of
        true ->
            {generator,
                fun(_capture) -> prng_ffi:random_float(_capture, From, To) end};

        false ->
            {generator,
                fun(_capture@1) ->
                    prng_ffi:random_float(_capture@1, To, From)
                end}
    end.

-file("src/prng/random.gleam", 221).
?DOC(
    " Always generates the given value, no matter the seed used.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let always_eleven = random.constant(11)\n"
    " random.random_sample(always_eleven)\n"
    " // -> 11\n"
    " ```\n"
).
-spec constant(AAUW) -> generator(AAUW).
constant(Value) ->
    {generator, fun(Seed) -> {Value, Seed} end}.

-file("src/prng/random.gleam", 476).
-spec do_fixed_size_list(list(AAWD), seed(), generator(AAWD), integer()) -> {list(AAWD),
    seed()}.
do_fixed_size_list(Acc, Seed, Generator, Length) ->
    case Length =< 0 of
        true ->
            {Acc, Seed};

        false ->
            {Value, Seed@1} = step(Generator, Seed),
            do_fixed_size_list([Value | Acc], Seed@1, Generator, Length - 1)
    end.

-file("src/prng/random.gleam", 469).
?DOC(
    " Generates a lists of a fixed size; its values are generated using the\n"
    " given generator.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Imagine you're modelling a game of\n"
    " [Risk](https://en.wikipedia.org/wiki/Risk_(game)); when a player \"attacks\"\n"
    " they can roll three dice. You may model that outcome using `fixed_size_list`\n"
    " like this:\n"
    "\n"
    " ```gleam\n"
    " let dice_roll = random.int(1, 6)\n"
    " let attack_outcome = random.fixed_size_list(dice_roll, 3)\n"
    " ```\n"
).
-spec fixed_size_list(generator(AAVZ), integer()) -> generator(list(AAVZ)).
fixed_size_list(Generator, Length) ->
    {generator,
        fun(_capture) -> do_fixed_size_list([], _capture, Generator, Length) end}.

-file("src/prng/random.gleam", 800).
?DOC(
    " Transforms a generator into another one based on its generated values.\n"
    "\n"
    " The random value generated by the given generator is fed into the `do`\n"
    " function and the returned generator is used as the new generator.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " `then` is a really powerful function, almost all functions exposed by this\n"
    " library could be defined in term of it!\n"
    " Take as an example `map`, it can be implemented like this:\n"
    "\n"
    " ```gleam\n"
    " fn map(generator: Generator(a), with fun: fn(a) -> b) -> Generator(b) {\n"
    "   random.then(generator, fn(value) {\n"
    "     random.constant(fun(value))\n"
    "   })\n"
    " }\n"
    " ```\n"
    "\n"
    " Notice how the `do` function needs to return a `Generator(b)`, you can\n"
    " achieve that by wrapping any constant value with the `random.constant`\n"
    " generator.\n"
    "\n"
    " > Code written with `then` can gain a lot in readability if you use the\n"
    " > `use` syntax, especially if it has some deep nesting. As an example, this\n"
    " > is how you can rewrite the previous example taking advantage of `use`:\n"
    " >\n"
    " > ```gleam\n"
    " > fn map(generator: Generator(a), with fun: fn(a) -> b) -> Generator(b) {\n"
    " >   use value <- random.then(generator)\n"
    " >   random.constant(fun(value))\n"
    " > }\n"
    " > ```\n"
).
-spec then(generator(AAYZ), fun((AAYZ) -> generator(AAZB))) -> generator(AAZB).
then(Generator, Generator_from) ->
    {generator,
        fun(Seed) ->
            {Value, Seed@1} = step(Generator, Seed),
            step(Generator_from(Value), Seed@1)
        end}.

-file("src/prng/random.gleam", 497).
?DOC(
    " Generates a list with a random size with at most 32 items.\n"
    " Each item is generated using the given generator.\n"
    "\n"
    " This is similar to `fixed_size_list` with the difference that the size\n"
    " is chosen randomly.\n"
).
-spec list(generator(AAWH)) -> generator(list(AAWH)).
list(Generator) ->
    then(int(0, 32), fun(_capture) -> fixed_size_list(Generator, _capture) end).

-file("src/prng/random.gleam", 387).
-spec get_by_weight({float(), AAVQ}, list({float(), AAVQ}), float()) -> AAVQ.
get_by_weight(First, Others, Countdown) ->
    {Weight, Value} = First,
    case Others of
        [] ->
            Value;

        [Second | Rest] ->
            Positive_weight = gleam@float:absolute_value(Weight),
            case Countdown > Positive_weight of
                false ->
                    Value;

                true ->
                    get_by_weight(Second, Rest, Countdown - Positive_weight)
            end
    end.

-file("src/prng/random.gleam", 827).
?DOC(
    " Transforms the values produced by a generator using the given function.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Imagine you want to make a generator for boolean values that returns\n"
    " `True` and `False` with the same probability. You could do that using `map`\n"
    " like this:\n"
    "\n"
    " ```gleam\n"
    " let bool_generator = random.int(1, 2) |> random.map(fn(n) { n == 1 })\n"
    " ```\n"
    "\n"
    " Here `map` allows you to transform the values produced by the initial\n"
    " integer generator - either 1 or 2 - into boolean values: when the original\n"
    " generator produces a 1, `bool_generator` will produce `True`; when the\n"
    " original generator produces a 2, `bool_generator` will produce `False`.\n"
).
-spec map(generator(AAZE), fun((AAZE) -> AAZG)) -> generator(AAZG).
map(Generator, Fun) ->
    {generator,
        fun(Seed) ->
            {Value, Seed@1} = step(Generator, Seed),
            {Fun(Value), Seed@1}
        end}.

-file("src/prng/random.gleam", 340).
-spec sum_absolute_values(list({float(), any()}), float()) -> float().
sum_absolute_values(List, Acc) ->
    case List of
        [] ->
            Acc;

        [{Value, _} | Rest] ->
            sum_absolute_values(Rest, Acc + gleam@float:absolute_value(Value))
    end.

-file("src/prng/random.gleam", 335).
?DOC(
    " Generates values from the given ones with a weighted probability.\n"
    "\n"
    " This generator can guarantee to produce values since it always takes at\n"
    " least one item (as its first argument); if it were to accept just a list of\n"
    " options, it could be called like this:\n"
    "\n"
    " ```gleam\n"
    " weighted([])\n"
    " ```\n"
    "\n"
    " In which case it would be impossible to actually produce any value: none was\n"
    " provided!\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Given the following type to model the outcome of a coin flip:\n"
    "\n"
    " ```gleam\n"
    " pub type CoinFlip {\n"
    "   Heads\n"
    "   Tails\n"
    " }\n"
    " ```\n"
    "\n"
    " You could write a generator for a loaded coin that lands on head 75% of the\n"
    " times like this:\n"
    "\n"
    " ```gleam\n"
    " let loaded_coin = random.weighted(#(0.75, Heads), [#(0.25, Tails)])\n"
    " ```\n"
    "\n"
    " In this example the weights add up to 1, but you could use any number: the\n"
    " weights get added up to a `total` and the probability of each option is its\n"
    " `weight` / `total`.\n"
).
-spec weighted({float(), AAVG}, list({float(), AAVG})) -> generator(AAVG).
weighted(First, Others) ->
    Total = sum_absolute_values(
        Others,
        gleam@float:absolute_value(erlang:element(1, First))
    ),
    map(
        float(+0.0, Total),
        fun(_capture) -> get_by_weight(First, Others, _capture) end
    ).

-file("src/prng/random.gleam", 257).
?DOC(
    " Generates values from the given ones with an equal probability.\n"
    "\n"
    " This generator can guarantee to produce values since it always takes at\n"
    " least one item (as its first argument); if it were to accept just a list of\n"
    " options, it could be called like this:\n"
    "\n"
    " ```gleam\n"
    " uniform([])\n"
    " ```\n"
    "\n"
    " In which case it would be impossible to actually produce any value: none was\n"
    " provided!\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Given the following type to model colors:\n"
    "\n"
    " ```gleam\n"
    " pub type Color {\n"
    "   Red\n"
    "   Green\n"
    "   Blue\n"
    " }\n"
    " ```\n"
    "\n"
    " You could write a generator that returns each color with an equal\n"
    " probability (~33%) each color like this:\n"
    "\n"
    " ```gleam\n"
    " let color = random.uniform(Red, [Green, Blue])\n"
    " ```\n"
).
-spec uniform(AAUY, list(AAUY)) -> generator(AAUY).
uniform(First, Others) ->
    weighted(
        {1.0, First},
        gleam@list:map(Others, fun(Value) -> {1.0, Value} end)
    ).

-file("src/prng/random.gleam", 293).
?DOC(
    " This function works exactly like `uniform` but will return an `Error(Nil)`\n"
    " if the provided argument is an empty list since the generator wouldn't be\n"
    " able to produce any value in that case.\n"
    "\n"
    " It generates values from the given list with equal probability.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " random.try_uniform([])\n"
    " // -> Error(Nil)\n"
    " ```\n"
    "\n"
    " For example if you consider the following type definition to model color:\n"
    "\n"
    " ```gleam\n"
    " type Color {\n"
    "   Red\n"
    "   Green\n"
    "   Blue\n"
    " }\n"
    " ```\n"
    "\n"
    " This call of `try_uniform` will produce a generator wrapped in an `Ok`:\n"
    "\n"
    " ```gleam\n"
    " let assert Ok(color_1) = random.try_uniform([Red, Green, Blue])\n"
    " let color_2 = random.uniform(Red, [Green, Blue])\n"
    " ```\n"
    "\n"
    " The generators `color_1` and `color_2` will behave exactly the same.\n"
).
-spec try_uniform(list(AAVB)) -> {ok, generator(AAVB)} | {error, nil}.
try_uniform(Options) ->
    case Options of
        [First | Rest] ->
            {ok, uniform(First, Rest)};

        [] ->
            {error, nil}
    end.

-file("src/prng/random.gleam", 380).
?DOC(
    " This function works exactly like `weighted` but will return an `Error(Nil)`\n"
    " if the provided argument is an empty list since the generator wouldn't be\n"
    " able to produce any value in that case.\n"
    "\n"
    " It generates values from the given list with a weighted probability.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " random.try_weighted([])\n"
    " // -> Error(Nil)\n"
    " ```\n"
    "\n"
    " For example if you consider the following type definition to model color:\n"
    "\n"
    " ```gleam\n"
    " type CoinFlip {\n"
    "   Heads\n"
    "   Tails\n"
    " }\n"
    " ```\n"
    "\n"
    " This call of `try_weighted` will produce a generator wrapped in an `Ok`:\n"
    "\n"
    " ```gleam\n"
    " let assert Ok(coin_1) =\n"
    "   random.try_weighted([#(0.75, Heads), #(0.25, Tails)])\n"
    " let coin_2 = random.uniform(#(0.75, Heads), [#(0.25, Tails)])\n"
    " ```\n"
    "\n"
    " The generators `coin_1` and `coin_2` will behave exactly the same.\n"
).
-spec try_weighted(list({float(), AAVL})) -> {ok, generator(AAVL)} |
    {error, nil}.
try_weighted(Options) ->
    case Options of
        [First | Rest] ->
            {ok, weighted(First, Rest)};

        [] ->
            {error, nil}
    end.

-file("src/prng/random.gleam", 427).
?DOC(
    " Generates two values with equal probability.\n"
    "\n"
    " This is a shorthand for `random.uniform(one, [other])`, but can read better\n"
    " when there's only two choices.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Given the following type to model the outcome of a coin flip:\n"
    "\n"
    " ```gleam\n"
    " pub type CoinFlip {\n"
    "   Heads\n"
    "   Tails\n"
    " }\n"
    " ```\n"
    "\n"
    " You can write a generator for coin flip outcomes like this:\n"
    "\n"
    " ```gleam\n"
    " let flip = random.choose(Heads, Tails)\n"
    " ```\n"
).
-spec choose(AAVS, AAVS) -> generator(AAVS).
choose(One, Other) ->
    uniform(One, [Other]).

-file("src/prng/random.gleam", 448).
?DOC(
    " Generates pairs of values obtained by combining the values produced by the\n"
    " given generators.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let one_to_five = random.int(1, 5)\n"
    " let probability = random.float(0.0, 1.0)\n"
    " let ints_and_floats = random.pair(one_to_five, probability)\n"
    "\n"
    " random.random_sample(ints_and_floats)\n"
    " // -> #(3, 0.22)\n"
    " ```\n"
).
-spec pair(generator(AAVU), generator(AAVW)) -> generator({AAVU, AAVW}).
pair(One, Other) ->
    then(One, fun(N) -> then(Other, fun(M) -> constant({N, M}) end) end).

-file("src/prng/random.gleam", 570).
?DOC(
    " Generates a `Map(k, v)` where each key value pair is generated using the\n"
    " provided generators.\n"
    "\n"
    " This is similar to `fixed_size_dict` with the difference that the map is\n"
    " going to have a random number of key-value pairs between 0 (inclusive) and\n"
    " 32 (inclusive).\n"
).
-spec dict(generator(any()), generator(any())) -> generator(gleam@dict:dict(any(), any())).
dict(Keys, Values) ->
    then(int(0, 32), fun(Size) -> fixed_size_dict(Keys, Values, Size) end).

-file("src/prng/random.gleam", 520).
-spec do_fixed_size_dict(
    generator(AAWQ),
    generator(AAWS),
    integer(),
    integer(),
    integer(),
    gleam@dict:dict(AAWQ, AAWS)
) -> generator(gleam@dict:dict(AAWQ, AAWS)).
do_fixed_size_dict(Keys, Values, Size, Unique_keys, Consecutive_attempts, Acc) ->
    Has_required_size = Unique_keys =:= Size,
    gleam@bool:guard(
        Has_required_size,
        constant(Acc),
        fun() ->
            Has_reached_maximum_attempts = Consecutive_attempts >= 10,
            gleam@bool:guard(
                Has_reached_maximum_attempts,
                constant(Acc),
                fun() ->
                    then(Keys, fun(Key) -> case gleam@dict:has_key(Acc, Key) of
                                true ->
                                    do_fixed_size_dict(
                                        Keys,
                                        Values,
                                        Size,
                                        Unique_keys,
                                        Consecutive_attempts + 1,
                                        Acc
                                    );

                                false ->
                                    then(
                                        Values,
                                        fun(Value) ->
                                            Unique_keys@1 = Unique_keys + 1,
                                            Acc@1 = gleam@dict:insert(
                                                Acc,
                                                Key,
                                                Value
                                            ),
                                            do_fixed_size_dict(
                                                Keys,
                                                Values,
                                                Size,
                                                Unique_keys@1,
                                                0,
                                                Acc@1
                                            )
                                        end
                                    )
                            end end)
                end
            )
        end
    ).

-file("src/prng/random.gleam", 511).
?DOC(
    " Generates a `Dict(k, v)` where each key value pair is generated using the\n"
    " provided generators.\n"
    "\n"
    " > ⚠️ This function makes a best effort at generating a map with exactly the\n"
    " > specified number of keys, but beware that it may contain less items if\n"
    " > the keys generator cannot generate enough distinct keys.\n"
).
-spec fixed_size_dict(generator(AAWL), generator(AAWN), integer()) -> generator(gleam@dict:dict(AAWL, AAWN)).
fixed_size_dict(Keys, Values, Size) ->
    _pipe = gleam@int:max(Size, 0),
    do_fixed_size_dict(Keys, Values, _pipe, 0, 0, maps:new()).

-file("src/prng/random.gleam", 636).
?DOC(
    " Generates a `Set(a)` where each item is generated using the provided\n"
    " generator.\n"
    "\n"
    " This is similar to `fixed_size_set` with the difference that the set is\n"
    " going to have a random size between 0 (inclusive) and 32 (inclusive).\n"
).
-spec set(generator(AAXN)) -> generator(gleam@set:set(AAXN)).
set(Generator) ->
    then(int(0, 32), fun(Size) -> fixed_size_set(Generator, Size) end).

-file("src/prng/random.gleam", 589).
-spec do_fixed_size_set(
    generator(AAXI),
    integer(),
    integer(),
    integer(),
    gleam@set:set(AAXI)
) -> generator(gleam@set:set(AAXI)).
do_fixed_size_set(Generator, Size, Unique_items, Consecutive_attempts, Acc) ->
    Has_required_size = Unique_items =:= Size,
    gleam@bool:guard(
        Has_required_size,
        constant(Acc),
        fun() ->
            Has_reached_maximum_attempts = Consecutive_attempts >= 10,
            gleam@bool:guard(
                Has_reached_maximum_attempts,
                constant(Acc),
                fun() ->
                    then(
                        Generator,
                        fun(Item) -> case gleam@set:contains(Acc, Item) of
                                true ->
                                    do_fixed_size_set(
                                        Generator,
                                        Size,
                                        Unique_items,
                                        Consecutive_attempts + 1,
                                        Acc
                                    );

                                false ->
                                    Unique_items@1 = Unique_items + 1,
                                    Acc@1 = gleam@set:insert(Acc, Item),
                                    do_fixed_size_set(
                                        Generator,
                                        Size,
                                        Unique_items@1,
                                        0,
                                        Acc@1
                                    )
                            end end
                    )
                end
            )
        end
    ).

-file("src/prng/random.gleam", 582).
?DOC(
    " Generates a `Set(a)` where each item is generated using the provided\n"
    " generator.\n"
    "\n"
    " > ⚠️ This function makes a best effort at generating a set with exactly the\n"
    " > specified number of items, but beware that it may contain less items if\n"
    " > the given generator cannot generate enough distinct values.\n"
).
-spec fixed_size_set(generator(AAXE), integer()) -> generator(gleam@set:set(AAXE)).
fixed_size_set(Generator, Size) ->
    do_fixed_size_set(Generator, gleam@int:max(Size, 0), 0, 0, gleam@set:new()).

-file("src/prng/random.gleam", 1011).
?DOC(
    " I'm not exposing this function because, if one is not careful with the range,\n"
    " it might lead to a nasty infinite loop.\n"
    " When I come up with a better alternative I might make a similar API public,\n"
    " for now, if someone wants to do something unsafe they will have to\n"
    " manually reimplement it.\n"
).
-spec utf_codepoint_in_range(integer(), integer()) -> generator(integer()).
utf_codepoint_in_range(Lower, Upper) ->
    then(
        int(Lower, Upper),
        fun(Raw_codepoint) -> case gleam@string:utf_codepoint(Raw_codepoint) of
                {ok, Codepoint} ->
                    constant(Codepoint);

                {error, _} ->
                    utf_codepoint_in_range(Lower, Upper)
            end end
    ).

-file("src/prng/random.gleam", 1000).
?DOC(
    " Generates Strings with the given number number of UTF code points.\n"
    "\n"
    " > ⚠️ The generated codepoints will be in the range from 0 (inclusive) to\n"
    " > 1023 (inclusive). If you feel like these strings are not enough for your\n"
    " > needs, please open an issue! I'd love to hear your use case and improve\n"
    " > the package.\n"
).
-spec fixed_size_string(integer()) -> generator(binary()).
fixed_size_string(Size) ->
    _pipe = fixed_size_list(utf_codepoint_in_range(0, 1023), Size),
    map(_pipe, fun gleam_stdlib:utf_codepoint_list_to_string/1).

-file("src/prng/random.gleam", 988).
?DOC(
    " Generates Strings with a random number of UTF code points, between\n"
    " 0 (included) and 32 (included).\n"
    "\n"
    " This is similar to `fixed_size_string`, with the difference that the\n"
    " size is randomly generated as well.\n"
).
-spec string() -> generator(binary()).
string() ->
    then(int(0, 32), fun(Size) -> fixed_size_string(Size) end).

-file("src/prng/random.gleam", 643).
?DOC(" Generates `BitArray`s with a random size.\n").
-spec bit_array() -> generator(bitstring()).
bit_array() ->
    map(string(), fun gleam_stdlib:identity/1).

-file("src/prng/random.gleam", 654).
-spec do_shuffle(list(AAXW), list({float(), AAXW})) -> generator(list(AAXW)).
do_shuffle(List, Acc) ->
    Slightly_less_than_1 = 1.0 - 2.2250738585072014e-308,
    case List of
        [] ->
            _pipe = gleam@list:sort(
                Acc,
                fun(One, Other) ->
                    gleam@float:compare(
                        erlang:element(1, One),
                        erlang:element(1, Other)
                    )
                end
            ),
            _pipe@1 = gleam@list:map(
                _pipe,
                fun(Pair) -> erlang:element(2, Pair) end
            ),
            constant(_pipe@1);

        [First | Rest] ->
            then(
                float(+0.0, Slightly_less_than_1),
                fun(Order) -> do_shuffle(Rest, [{Order, First} | Acc]) end
            )
    end.

-file("src/prng/random.gleam", 650).
?DOC(
    " Generates lists with the same element of the given one, but in a random\n"
    " order.\n"
).
-spec shuffle(list(AAXS)) -> generator(list(AAXS)).
shuffle(List) ->
    do_shuffle(List, []).

-file("src/prng/random.gleam", 724).
-spec log_random() -> generator(float()).
log_random() ->
    Slightly_less_than_1 = 1.0 - 2.2250738585072014e-308,
    then(
        float(+0.0, Slightly_less_than_1),
        fun(Float) ->
            Random@1 = case gleam@float:logarithm(
                Float + 2.2250738585072014e-308
            ) of
                {ok, Random} -> Random;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"prng/random"/utf8>>,
                                function => <<"log_random"/utf8>>,
                                line => 727,
                                value => _assert_fail,
                                start => 21492,
                                'end' => 21554,
                                pattern_start => 21503,
                                pattern_end => 21513})
            end,
            constant(Random@1)
        end
    ).

-file("src/prng/random.gleam", 700).
-spec sample_loop(
    list(AAYF),
    gleam@dict:dict(integer(), AAYF),
    integer(),
    float()
) -> generator(gleam@dict:dict(integer(), AAYF)).
sample_loop(List, Reservoir, N, W) ->
    Log@1 = case gleam@float:logarithm(1.0 - W) of
        {ok, Log} -> Log;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"prng/random"/utf8>>,
                        function => <<"sample_loop"/utf8>>,
                        line => 706,
                        value => _assert_fail,
                        start => 20804,
                        'end' => 20850,
                        pattern_start => 20815,
                        pattern_end => 20822})
    end,
    then(
        log_random(),
        fun(Log_randon) ->
            Skip = erlang:round(math:floor(case Log@1 of
                        +0.0 -> +0.0;
                        -0.0 -> -0.0;
                        Gleam@denominator -> Log_randon / Gleam@denominator
                    end)),
            case gleam@list:drop(List, Skip) of
                [] ->
                    constant(Reservoir);

                [First | Rest] ->
                    then(
                        int(0, N - 1),
                        fun(Position) ->
                            then(
                                log_random(),
                                fun(Log_random) ->
                                    Reservoir@1 = gleam@dict:insert(
                                        Reservoir,
                                        Position,
                                        First
                                    ),
                                    W@1 = W * math:exp(case erlang:float(N) of
                                            +0.0 -> +0.0;
                                            -0.0 -> -0.0;
                                            Gleam@denominator@1 -> Log_random / Gleam@denominator@1
                                        end),
                                    sample_loop(Rest, Reservoir@1, N, W@1)
                                end
                            )
                        end
                    )
            end
        end
    ).

-file("src/prng/random.gleam", 742).
-spec build_reservoir_loop(
    list(AAYS),
    integer(),
    gleam@dict:dict(integer(), AAYS)
) -> {gleam@dict:dict(integer(), AAYS), list(AAYS)}.
build_reservoir_loop(List, Size, Reservoir) ->
    Reservoir_size = maps:size(Reservoir),
    case Reservoir_size >= Size of
        true ->
            {Reservoir, List};

        false ->
            case List of
                [] ->
                    {Reservoir, []};

                [First | Rest] ->
                    Reservoir@1 = gleam@dict:insert(
                        Reservoir,
                        Reservoir_size,
                        First
                    ),
                    build_reservoir_loop(Rest, Size, Reservoir@1)
            end
    end.

-file("src/prng/random.gleam", 738).
?DOC(
    " Builds the initial reservoir used by Algorithm L.\n"
    " This is a dictionary with keys ranging from `0` up to `n - 1` where each\n"
    " value is the corresponding element at that position in `list`.\n"
    "\n"
    " This also returns the remaining elements of `list` that didn't end up in\n"
    " the reservoir.\n"
).
-spec build_reservoir(list(AAYN), integer()) -> {gleam@dict:dict(integer(), AAYN),
    list(AAYN)}.
build_reservoir(List, N) ->
    build_reservoir_loop(List, N, maps:new()).

-file("src/prng/random.gleam", 682).
?DOC(
    " Generates random samples of up to n elements from a list using reservoir\n"
    " sampling via [Algorithm L](https://en.wikipedia.org/wiki/Reservoir_sampling#Optimal:_Algorithm_L).\n"
    " Returns an empty list if the sample size is less than or equal to 0.\n"
    "\n"
    " Order is not random, only selection is.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " sample([1, 2, 3, 4, 5], 3)\n"
    " // some samples could be: [2, 4, 5], [1, 4, 5], ...\n"
    " ```\n"
).
-spec sample(list(AAYB), integer()) -> generator(list(AAYB)).
sample(List, N) ->
    {Reservoir, Rest} = build_reservoir(List, N),
    case gleam@dict:is_empty(Reservoir) of
        true ->
            constant([]);

        false ->
            then(
                log_random(),
                fun(Log_random) ->
                    W = math:exp(case erlang:float(N) of
                            +0.0 -> +0.0;
                            -0.0 -> -0.0;
                            Gleam@denominator -> Log_random / Gleam@denominator
                        end),
                    _pipe = sample_loop(Rest, Reservoir, N, W),
                    map(_pipe, fun maps:values/1)
                end
            )
    end.

-file("src/prng/random.gleam", 873).
?DOC(
    " Combines two generators into a single one. The resulting generator produces\n"
    " values obtained by applying `fun` to the values generated by the given\n"
    " generators.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Imagine you need to generate random points in a 2D space:\n"
    "\n"
    " ```gleam\n"
    " pub type Point {\n"
    "   Point(x: Float, y: Float)\n"
    " }\n"
    " ```\n"
    "\n"
    " You can compose two basic generators into a `Point` generator using `map2`:\n"
    "\n"
    " ```gleam\n"
    " let x_generator = random.float(-1.0, 1.0)\n"
    " let y_generator = random.float(-1.0, 1.0)\n"
    " let point_generator = map2(x_generator, y_generator, Point)\n"
    " ```\n"
    "\n"
    " > Notice how you could get the same result using `then`:\n"
    " >\n"
    " > ```gleam\n"
    " > pub fn point_generator() -> Generator(Point) {\n"
    " >   use x <- random.then(random.float(-1.0, 1.0))\n"
    " >   use y <- random.then(random.float(-1.0, 1.0))\n"
    " >   random.constant(Point(x, y))\n"
    " > }\n"
    " > ```\n"
    " >\n"
    " > the `use` syntax paired with `then` may be confusing for other people\n"
    " > reading your code, especially Gleam newcomers.\n"
    " >\n"
    " > Usually `map2`/`map3`/... will be more than enough if you just need to\n"
    " > combine simple generators into more complex ones.\n"
).
-spec map2(generator(AAZI), generator(AAZK), fun((AAZI, AAZK) -> AAZM)) -> generator(AAZM).
map2(One, Other, Fun) ->
    {generator,
        fun(Seed) ->
            {A, Seed@1} = step(One, Seed),
            {B, Seed@2} = step(Other, Seed@1),
            {Fun(A, B), Seed@2}
        end}.

-file("src/prng/random.gleam", 919).
?DOC(
    " Combines three generators into a single one. The resulting generator\n"
    " produces values obtained by applying `fun` to the values generated by the\n"
    " given generators.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " Imagine you're writing a generator for random enemies in a game you're\n"
    " making:\n"
    "\n"
    " ```gleam\n"
    " pub type Enemy {\n"
    "   Enemy(health: Int, attack: Int, defense: Int)\n"
    " }\n"
    " ```\n"
    "\n"
    " Each enemy starts with a random health (that can go from 50 to 100) and\n"
    " random values for the `attack` and `defense` stats (each can be in a range\n"
    " from 1 to 5):\n"
    "\n"
    " ```gleam\n"
    " let health_generator = random.int(50, 100)\n"
    " let attack_generator = random.int(1, 5)\n"
    " let defense_generator = random.int(1, 5)\n"
    "\n"
    " let enemy_generator =\n"
    "   random.map3(\n"
    "     health_generator,\n"
    "     attack_generator,\n"
    "     defense_generator,\n"
    "     Enemy,\n"
    "   )\n"
    " ```\n"
).
-spec map3(
    generator(AAZO),
    generator(AAZQ),
    generator(AAZS),
    fun((AAZO, AAZQ, AAZS) -> AAZU)
) -> generator(AAZU).
map3(One, Two, Three, Fun) ->
    {generator,
        fun(Seed) ->
            {A, Seed@1} = step(One, Seed),
            {B, Seed@2} = step(Two, Seed@1),
            {C, Seed@3} = step(Three, Seed@2),
            {Fun(A, B, C), Seed@3}
        end}.

-file("src/prng/random.gleam", 938).
?DOC(
    " Combines four generators into a single one. The resulting generator\n"
    " produces values obtained by applying `fun` to the values generated by the\n"
    " given generators.\n"
).
-spec map4(
    generator(AAZW),
    generator(AAZY),
    generator(ABAA),
    generator(ABAC),
    fun((AAZW, AAZY, ABAA, ABAC) -> ABAE)
) -> generator(ABAE).
map4(One, Two, Three, Four, Fun) ->
    {generator,
        fun(Seed) ->
            {A, Seed@1} = step(One, Seed),
            {B, Seed@2} = step(Two, Seed@1),
            {C, Seed@3} = step(Three, Seed@2),
            {D, Seed@4} = step(Four, Seed@3),
            {Fun(A, B, C, D), Seed@4}
        end}.

-file("src/prng/random.gleam", 962).
?DOC(
    " Combines five generators into a single one. The resulting generator\n"
    " produces values obtained by applying `fun` to the values generated by the\n"
    " given generators.\n"
    "\n"
    " > There's no `map6`, `map7`, and so on. If you feel like you need to compose\n"
    " > together even more generators, you can use the `random.then` function.\n"
).
-spec map5(
    generator(ABAG),
    generator(ABAI),
    generator(ABAK),
    generator(ABAM),
    generator(ABAO),
    fun((ABAG, ABAI, ABAK, ABAM, ABAO) -> ABAQ)
) -> generator(ABAQ).
map5(One, Two, Three, Four, Five, Fun) ->
    {generator,
        fun(Seed) ->
            {A, Seed@1} = step(One, Seed),
            {B, Seed@2} = step(Two, Seed@1),
            {C, Seed@3} = step(Three, Seed@2),
            {D, Seed@4} = step(Four, Seed@3),
            {E, Seed@5} = step(Five, Seed@4),
            {Fun(A, B, C, D, E), Seed@5}
        end}.
