-module(encode_decode_roundtrip_test).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "test/encode_decode_roundtrip_test.gleam").
-export([encode_decode_roundtrip_test/0]).

-file("test/encode_decode_roundtrip_test.gleam", 6).
-spec encode_decode_roundtrip_test() -> nil.
encode_decode_roundtrip_test() ->
    Config = begin
        _pipe = qcheck:default_config(),
        qcheck:with_test_count(_pipe, 10)
    end,
    qcheck:run(
        Config,
        pandi@generator:document_generator(),
        fun(Doc) ->
            Json = pandi:to_json(Doc),
            Decoded = pandi:from_json(Json),
            _pipe@1 = Decoded,
            gleeunit@should:equal(_pipe@1, {ok, Doc})
        end
    ).
