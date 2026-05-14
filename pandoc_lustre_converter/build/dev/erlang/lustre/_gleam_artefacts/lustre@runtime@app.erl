-module(lustre@runtime@app).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/runtime/app.gleam").
-export([configure/1, configure_server_component/1]).
-export_type([app/3, config/1, option/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type app(WJX, WJY, WJZ) :: {app,
        gleam@option:option(gleam@erlang@process:name(lustre@runtime@server@runtime:message(WJZ))),
        fun((WJX) -> {WJY, lustre@effect:effect(WJZ)}),
        fun((WJY, WJZ) -> {WJY, lustre@effect:effect(WJZ)}),
        fun((WJY) -> lustre@vdom@vnode:element(WJZ)),
        config(WJZ)}.

-type config(WKA) :: {config,
        boolean(),
        boolean(),
        boolean(),
        list({binary(), fun((binary()) -> {ok, WKA} | {error, nil})}),
        list({binary(), gleam@dynamic@decode:decoder(WKA)}),
        list({binary(), gleam@dynamic@decode:decoder(WKA)}),
        boolean(),
        gleam@option:option(fun((binary()) -> WKA)),
        gleam@option:option(WKA),
        gleam@option:option(fun((binary()) -> WKA)),
        gleam@option:option(WKA),
        gleam@option:option(WKA),
        gleam@option:option(WKA)}.

-type option(WKB) :: {option, fun((config(WKB)) -> config(WKB))}.

-file("src/lustre/runtime/app.gleam", 71).
?DOC(false).
-spec configure(list(option(WKC))) -> config(WKC).
configure(Options) ->
    gleam@list:fold(
        Options,
        {config,
            true,
            true,
            false,
            [],
            [],
            [],
            false,
            none,
            none,
            none,
            none,
            none,
            none},
        fun(Config, Option) -> (erlang:element(2, Option))(Config) end
    ).

-file("src/lustre/runtime/app.gleam", 75).
?DOC(false).
-spec configure_server_component(config(WKG)) -> lustre@runtime@server@runtime:config(WKG).
configure_server_component(Config) ->
    {config,
        erlang:element(2, Config),
        erlang:element(3, Config),
        maps:from_list(lists:reverse(erlang:element(5, Config))),
        maps:from_list(lists:reverse(erlang:element(6, Config))),
        maps:from_list(lists:reverse(erlang:element(7, Config))),
        erlang:element(12, Config),
        erlang:element(14, Config)}.
