-module(pandi@decode).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/decode.gleam").
-export([document_decoder/0]).

-file("src/pandi/decode.gleam", 143).
-spec target_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:target()).
target_decoder() ->
    gleam@dynamic@decode:field(
        0,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Url) ->
            gleam@dynamic@decode:field(
                1,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Title) ->
                    gleam@dynamic@decode:success({target, Url, Title})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 215).
-spec decode_c_at(
    integer(),
    gleam@dynamic@decode:decoder(CKK),
    fun((CKK) -> gleam@dynamic@decode:decoder(CKM))
) -> gleam@dynamic@decode:decoder(CKM).
decode_c_at(Index, Decoder, Next) ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:at([Index], Decoder),
        fun(Value) -> Next(Value) end
    ).

-file("src/pandi/decode.gleam", 209).
-spec keyvalue_decoder() -> gleam@dynamic@decode:decoder({binary(), binary()}).
keyvalue_decoder() ->
    gleam@dynamic@decode:field(
        0,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Key) ->
            gleam@dynamic@decode:field(
                1,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Value) -> gleam@dynamic@decode:success({Key, Value}) end
            )
        end
    ).

-file("src/pandi/decode.gleam", 202).
-spec attributes_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:attributes()).
attributes_decoder() ->
    gleam@dynamic@decode:field(
        0,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                1,
                gleam@dynamic@decode:list(
                    {decoder, fun gleam@dynamic@decode:decode_string/1}
                ),
                fun(Classes) ->
                    gleam@dynamic@decode:field(
                        2,
                        gleam@dynamic@decode:list(keyvalue_decoder()),
                        fun(Keyvalues) ->
                            gleam@dynamic@decode:success(
                                {attributes, Id, Classes, Keyvalues}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 196).
-spec code_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
code_decoder() ->
    decode_c_at(
        0,
        attributes_decoder(),
        fun(Attributes) ->
            decode_c_at(
                1,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Text) ->
                    gleam@dynamic@decode:success({code, Attributes, Text})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 168).
-spec soft_break_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
soft_break_decoder() ->
    gleam@dynamic@decode:success(soft_break).

-file("src/pandi/decode.gleam", 164).
-spec line_break_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
line_break_decoder() ->
    gleam@dynamic@decode:success(line_break).

-file("src/pandi/decode.gleam", 160).
-spec space_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
space_decoder() ->
    gleam@dynamic@decode:success(space).

-file("src/pandi/decode.gleam", 155).
-spec str_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
str_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Content) -> gleam@dynamic@decode:success({str, Content}) end
    ).

-file("src/pandi/decode.gleam", 136).
-spec link_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
link_decoder() ->
    decode_c_at(
        0,
        attributes_decoder(),
        fun(Attributes) ->
            decode_c_at(
                1,
                gleam@dynamic@decode:list(
                    gleam@dynamic@decode:recursive(fun inline_decoder/0)
                ),
                fun(Content) ->
                    decode_c_at(
                        2,
                        target_decoder(),
                        fun(Target) ->
                            gleam@dynamic@decode:success(
                                {link, Attributes, Content, Target}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 149).
-spec span_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
span_decoder() ->
    decode_c_at(
        0,
        attributes_decoder(),
        fun(Attributes) ->
            decode_c_at(
                1,
                gleam@dynamic@decode:list(
                    gleam@dynamic@decode:recursive(fun inline_decoder/0)
                ),
                fun(Content) ->
                    gleam@dynamic@decode:success({span, Attributes, Content})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 188).
-spec strikeout_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
strikeout_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(
            gleam@dynamic@decode:recursive(fun inline_decoder/0)
        ),
        fun(Content) -> gleam@dynamic@decode:success({strikeout, Content}) end
    ).

-file("src/pandi/decode.gleam", 180).
-spec strong_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
strong_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(
            gleam@dynamic@decode:recursive(fun inline_decoder/0)
        ),
        fun(Content) -> gleam@dynamic@decode:success({strong, Content}) end
    ).

-file("src/pandi/decode.gleam", 172).
-spec emph_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
emph_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(
            gleam@dynamic@decode:recursive(fun inline_decoder/0)
        ),
        fun(Content) -> gleam@dynamic@decode:success({emph, Content}) end
    ).

-file("src/pandi/decode.gleam", 119).
-spec inline_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:inline()).
inline_decoder() ->
    gleam@dynamic@decode:field(
        <<"t"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(T) -> case T of
                <<"Str"/utf8>> ->
                    str_decoder();

                <<"Space"/utf8>> ->
                    space_decoder();

                <<"LineBreak"/utf8>> ->
                    line_break_decoder();

                <<"SoftBreak"/utf8>> ->
                    soft_break_decoder();

                <<"Emph"/utf8>> ->
                    emph_decoder();

                <<"Strong"/utf8>> ->
                    strong_decoder();

                <<"Strikeout"/utf8>> ->
                    strikeout_decoder();

                <<"Code"/utf8>> ->
                    code_decoder();

                <<"Span"/utf8>> ->
                    span_decoder();

                <<"Link"/utf8>> ->
                    link_decoder();

                _ ->
                    gleam@dynamic@decode:failure(space, <<"Inline"/utf8>>)
            end end
    ).

-file("src/pandi/decode.gleam", 16).
-spec meta_value_decoder() -> gleam@dynamic@decode:decoder(binary()).
meta_value_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(inline_decoder()),
        fun(Content) -> case Content of
                [{str, Val}] ->
                    gleam@dynamic@decode:success(Val);

                _ ->
                    gleam@dynamic@decode:failure(
                        <<""/utf8>>,
                        <<"pd.MetaInlines"/utf8>>
                    )
            end end
    ).

-file("src/pandi/decode.gleam", 11).
-spec meta_decoder() -> gleam@dynamic@decode:decoder(list({binary(), binary()})).
meta_decoder() ->
    _pipe = gleam@dynamic@decode:dict(
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        meta_value_decoder()
    ),
    gleam@dynamic@decode:map(_pipe, fun maps:to_list/1).

-file("src/pandi/decode.gleam", 109).
-spec list_number_delimiter_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:list_number_delimiter()).
list_number_delimiter_decoder() ->
    gleam@dynamic@decode:field(
        <<"t"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(T) -> case T of
                <<"Period"/utf8>> ->
                    gleam@dynamic@decode:success(period);

                <<"OneParen"/utf8>> ->
                    gleam@dynamic@decode:success(one_paren);

                <<"TwoParens"/utf8>> ->
                    gleam@dynamic@decode:success(two_parens);

                _ ->
                    gleam@dynamic@decode:failure(
                        period,
                        <<"ListNumberDelimiter"/utf8>>
                    )
            end end
    ).

-file("src/pandi/decode.gleam", 97).
-spec list_number_style_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:list_number_style()).
list_number_style_decoder() ->
    gleam@dynamic@decode:field(
        <<"t"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(T) -> case T of
                <<"Decimal"/utf8>> ->
                    gleam@dynamic@decode:success(decimal);

                <<"LowerAlpha"/utf8>> ->
                    gleam@dynamic@decode:success(lower_alpha);

                <<"UpperAlpha"/utf8>> ->
                    gleam@dynamic@decode:success(upper_alpha);

                <<"LowerRoman"/utf8>> ->
                    gleam@dynamic@decode:success(lower_roman);

                <<"UpperRoman"/utf8>> ->
                    gleam@dynamic@decode:success(upper_roman);

                _ ->
                    gleam@dynamic@decode:failure(
                        decimal,
                        <<"ListNumberStyle"/utf8>>
                    )
            end end
    ).

-file("src/pandi/decode.gleam", 90).
-spec list_attributes_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:list_attributes()).
list_attributes_decoder() ->
    gleam@dynamic@decode:field(
        0,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Start) ->
            gleam@dynamic@decode:field(
                1,
                list_number_style_decoder(),
                fun(Style) ->
                    gleam@dynamic@decode:field(
                        2,
                        list_number_delimiter_decoder(),
                        fun(Delimiter) ->
                            gleam@dynamic@decode:success(
                                {list_attributes, Start, Style, Delimiter}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 56).
-spec code_block_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
code_block_decoder() ->
    decode_c_at(
        0,
        attributes_decoder(),
        fun(Attributes) ->
            decode_c_at(
                1,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Text) ->
                    gleam@dynamic@decode:success({code_block, Attributes, Text})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 51).
-spec plain_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
plain_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(inline_decoder()),
        fun(Content) -> gleam@dynamic@decode:success({plain, Content}) end
    ).

-file("src/pandi/decode.gleam", 46).
-spec para_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
para_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(inline_decoder()),
        fun(Content) -> gleam@dynamic@decode:success({para, Content}) end
    ).

-file("src/pandi/decode.gleam", 39).
-spec header_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
header_decoder() ->
    decode_c_at(
        0,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Level) ->
            decode_c_at(
                1,
                attributes_decoder(),
                fun(Attributes) ->
                    decode_c_at(
                        2,
                        gleam@dynamic@decode:list(inline_decoder()),
                        fun(Content) ->
                            gleam@dynamic@decode:success(
                                {header, Level, Attributes, Content}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 85).
-spec block_quote_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
block_quote_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(
            gleam@dynamic@decode:recursive(fun block_decoder/0)
        ),
        fun(Content) -> gleam@dynamic@decode:success({block_quote, Content}) end
    ).

-file("src/pandi/decode.gleam", 76).
-spec ordered_list_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
ordered_list_decoder() ->
    decode_c_at(
        0,
        list_attributes_decoder(),
        fun(Attrs) ->
            decode_c_at(
                1,
                gleam@dynamic@decode:list(
                    gleam@dynamic@decode:list(
                        gleam@dynamic@decode:recursive(fun block_decoder/0)
                    )
                ),
                fun(Items) ->
                    gleam@dynamic@decode:success({ordered_list, Attrs, Items})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 68).
-spec bullet_list_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
bullet_list_decoder() ->
    gleam@dynamic@decode:field(
        <<"c"/utf8>>,
        gleam@dynamic@decode:list(
            gleam@dynamic@decode:list(
                gleam@dynamic@decode:recursive(fun block_decoder/0)
            )
        ),
        fun(Items) -> gleam@dynamic@decode:success({bullet_list, Items}) end
    ).

-file("src/pandi/decode.gleam", 62).
-spec div_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
div_decoder() ->
    decode_c_at(
        0,
        attributes_decoder(),
        fun(Attributes) ->
            decode_c_at(
                1,
                gleam@dynamic@decode:list(
                    gleam@dynamic@decode:recursive(fun block_decoder/0)
                ),
                fun(Content) ->
                    gleam@dynamic@decode:success({'div', Attributes, Content})
                end
            )
        end
    ).

-file("src/pandi/decode.gleam", 24).
-spec block_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:block()).
block_decoder() ->
    gleam@dynamic@decode:field(
        <<"t"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(T) -> case T of
                <<"Header"/utf8>> ->
                    header_decoder();

                <<"Para"/utf8>> ->
                    para_decoder();

                <<"Plain"/utf8>> ->
                    plain_decoder();

                <<"CodeBlock"/utf8>> ->
                    code_block_decoder();

                <<"Div"/utf8>> ->
                    div_decoder();

                <<"BulletList"/utf8>> ->
                    bullet_list_decoder();

                <<"OrderedList"/utf8>> ->
                    ordered_list_decoder();

                <<"BlockQuote"/utf8>> ->
                    block_quote_decoder();

                _ ->
                    gleam@dynamic@decode:failure({para, []}, <<"Block"/utf8>>)
            end end
    ).

-file("src/pandi/decode.gleam", 5).
-spec document_decoder() -> gleam@dynamic@decode:decoder(pandi@pandoc:document()).
document_decoder() ->
    gleam@dynamic@decode:field(
        <<"blocks"/utf8>>,
        gleam@dynamic@decode:list(block_decoder()),
        fun(Blocks) ->
            gleam@dynamic@decode:field(
                <<"meta"/utf8>>,
                meta_decoder(),
                fun(Meta) ->
                    gleam@dynamic@decode:success({document, Blocks, Meta})
                end
            )
        end
    ).
