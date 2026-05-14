-module(javascript_dom_parser).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/javascript_dom_parser.gleam").
-export_type([html_node/0, dom/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " Bindings to the JavaScript `DOMParser` API, to enable parsing of HTML in\n"
    " the browser with Gleam. And any other JavaScript runtimes that have\n"
    " `DOMParser`.\n"
    "\n"
).

-type html_node() :: {element,
        binary(),
        list({binary(), binary()}),
        list(html_node())} |
    {text, binary()} |
    {comment, binary()}.

-type dom() :: any().


