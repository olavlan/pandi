-module(pandi).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi.gleam").
-export([to_json/1, from_json/1]).

-file("src/pandi.gleam", 6).
-spec to_json(pandi@pandoc:document()) -> binary().
to_json(Doc) ->
    _pipe = Doc,
    _pipe@1 = pandi@encode:encode_document(_pipe),
    gleam@json:to_string(_pipe@1).

-file("src/pandi.gleam", 12).
-spec from_json(binary()) -> {ok, pandi@pandoc:document()} |
    {error, gleam@json:decode_error()}.
from_json(Json_string) ->
    gleam@json:parse(Json_string, pandi@decode:document_decoder()).
