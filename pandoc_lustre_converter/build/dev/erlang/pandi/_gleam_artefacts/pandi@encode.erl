-module(pandi@encode).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/encode.gleam").
-export([encode_document/1]).

-file("src/pandi/encode.gleam", 233).
-spec encode_list_number_delimiter(pandi@pandoc:list_number_delimiter()) -> gleam@json:json().
encode_list_number_delimiter(Delim) ->
    T = case Delim of
        period ->
            <<"Period"/utf8>>;

        one_paren ->
            <<"OneParen"/utf8>>;

        two_parens ->
            <<"TwoParens"/utf8>>
    end,
    gleam@json:object([{<<"t"/utf8>>, gleam@json:string(T)}]).

-file("src/pandi/encode.gleam", 222).
-spec encode_list_number_style(pandi@pandoc:list_number_style()) -> gleam@json:json().
encode_list_number_style(Style) ->
    T = case Style of
        decimal ->
            <<"Decimal"/utf8>>;

        lower_alpha ->
            <<"LowerAlpha"/utf8>>;

        upper_alpha ->
            <<"UpperAlpha"/utf8>>;

        lower_roman ->
            <<"LowerRoman"/utf8>>;

        upper_roman ->
            <<"UpperRoman"/utf8>>
    end,
    gleam@json:object([{<<"t"/utf8>>, gleam@json:string(T)}]).

-file("src/pandi/encode.gleam", 214).
-spec encode_list_attributes(pandi@pandoc:list_attributes()) -> gleam@json:json().
encode_list_attributes(Attrs) ->
    gleam@json:preprocessed_array(
        [gleam@json:int(erlang:element(2, Attrs)),
            encode_list_number_style(erlang:element(3, Attrs)),
            encode_list_number_delimiter(erlang:element(4, Attrs))]
    ).

-file("src/pandi/encode.gleam", 196).
-spec encode_keyvalue({binary(), binary()}) -> gleam@json:json().
encode_keyvalue(Keyvalue) ->
    gleam@json:preprocessed_array(
        [gleam@json:string(erlang:element(1, Keyvalue)),
            gleam@json:string(erlang:element(2, Keyvalue))]
    ).

-file("src/pandi/encode.gleam", 188).
-spec encode_attributes(pandi@pandoc:attributes()) -> gleam@json:json().
encode_attributes(Attrs) ->
    gleam@json:preprocessed_array(
        [gleam@json:string(erlang:element(2, Attrs)),
            gleam@json:array(erlang:element(3, Attrs), fun gleam@json:string/1),
            gleam@json:array(erlang:element(4, Attrs), fun encode_keyvalue/1)]
    ).

-file("src/pandi/encode.gleam", 140).
-spec encode_code_block_content(pandi@pandoc:attributes(), binary()) -> gleam@json:json().
encode_code_block_content(Attributes, Text) ->
    gleam@json:preprocessed_array(
        [encode_attributes(Attributes), gleam@json:string(Text)]
    ).

-file("src/pandi/encode.gleam", 172).
-spec encode_target(pandi@pandoc:target()) -> gleam@json:json().
encode_target(Target) ->
    gleam@json:preprocessed_array(
        [gleam@json:string(erlang:element(2, Target)),
            gleam@json:string(erlang:element(3, Target))]
    ).

-file("src/pandi/encode.gleam", 123).
-spec encode_code_content(pandi@pandoc:attributes(), binary()) -> gleam@json:json().
encode_code_content(Attributes, Text) ->
    gleam@json:preprocessed_array(
        [encode_attributes(Attributes), gleam@json:string(Text)]
    ).

-file("src/pandi/encode.gleam", 160).
-spec encode_link_content(
    pandi@pandoc:attributes(),
    list(pandi@pandoc:inline()),
    pandi@pandoc:target()
) -> gleam@json:json().
encode_link_content(Attributes, Content, Target) ->
    gleam@json:preprocessed_array(
        [encode_attributes(Attributes),
            gleam@json:array(Content, fun encode_inline/1),
            encode_target(Target)]
    ).

-file("src/pandi/encode.gleam", 150).
-spec encode_span_content(
    pandi@pandoc:attributes(),
    list(pandi@pandoc:inline())
) -> gleam@json:json().
encode_span_content(Attributes, Content) ->
    gleam@json:preprocessed_array(
        [encode_attributes(Attributes),
            gleam@json:array(Content, fun encode_inline/1)]
    ).

-file("src/pandi/encode.gleam", 71).
-spec encode_inline(pandi@pandoc:inline()) -> gleam@json:json().
encode_inline(Inline) ->
    case Inline of
        {str, Content} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Str"/utf8>>)},
                    {<<"c"/utf8>>, gleam@json:string(Content)}]
            );

        space ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Space"/utf8>>)}]
            );

        line_break ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"LineBreak"/utf8>>)}]
            );

        soft_break ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"SoftBreak"/utf8>>)}]
            );

        {emph, Content@1} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Emph"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@1, fun encode_inline/1)}]
            );

        {strong, Content@2} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Strong"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@2, fun encode_inline/1)}]
            );

        {strikeout, Content@3} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Strikeout"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@3, fun encode_inline/1)}]
            );

        {code, Attributes, Text} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Code"/utf8>>)},
                    {<<"c"/utf8>>, encode_code_content(Attributes, Text)}]
            );

        {span, Attributes@1, Content@4} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Span"/utf8>>)},
                    {<<"c"/utf8>>, encode_span_content(Attributes@1, Content@4)}]
            );

        {link, Attributes@2, Content@5, Target} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Link"/utf8>>)},
                    {<<"c"/utf8>>,
                        encode_link_content(Attributes@2, Content@5, Target)}]
            )
    end.

-file("src/pandi/encode.gleam", 176).
-spec encode_header_content(
    integer(),
    pandi@pandoc:attributes(),
    list(pandi@pandoc:inline())
) -> gleam@json:json().
encode_header_content(Level, Attributes, Content) ->
    gleam@json:preprocessed_array(
        [gleam@json:int(Level),
            encode_attributes(Attributes),
            gleam@json:array(Content, fun encode_inline/1)]
    ).

-file("src/pandi/encode.gleam", 200).
-spec encode_bullet_list_item(list(pandi@pandoc:block())) -> gleam@json:json().
encode_bullet_list_item(Item) ->
    gleam@json:array(Item, fun encode_block/1).

-file("src/pandi/encode.gleam", 204).
-spec encode_ordered_list_content(
    pandi@pandoc:list_attributes(),
    list(list(pandi@pandoc:block()))
) -> gleam@json:json().
encode_ordered_list_content(Attrs, Items) ->
    gleam@json:preprocessed_array(
        [encode_list_attributes(Attrs),
            gleam@json:array(Items, fun encode_bullet_list_item/1)]
    ).

-file("src/pandi/encode.gleam", 130).
-spec encode_div_content(pandi@pandoc:attributes(), list(pandi@pandoc:block())) -> gleam@json:json().
encode_div_content(Attributes, Content) ->
    Encoded_attributes = encode_attributes(Attributes),
    Encoded_content = gleam@json:array(Content, fun encode_block/1),
    gleam@json:preprocessed_array([Encoded_attributes, Encoded_content]).

-file("src/pandi/encode.gleam", 26).
-spec encode_block(pandi@pandoc:block()) -> gleam@json:json().
encode_block(Block) ->
    case Block of
        {header, Level, Attributes, Content} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Header"/utf8>>)},
                    {<<"c"/utf8>>,
                        encode_header_content(Level, Attributes, Content)}]
            );

        {para, Content@1} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Para"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@1, fun encode_inline/1)}]
            );

        {plain, Content@2} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Plain"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@2, fun encode_inline/1)}]
            );

        {code_block, Attributes@1, Text} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"CodeBlock"/utf8>>)},
                    {<<"c"/utf8>>,
                        encode_code_block_content(Attributes@1, Text)}]
            );

        {'div', Attributes@2, Content@3} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"Div"/utf8>>)},
                    {<<"c"/utf8>>, encode_div_content(Attributes@2, Content@3)}]
            );

        {bullet_list, Items} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"BulletList"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Items, fun encode_bullet_list_item/1)}]
            );

        {ordered_list, Attrs, Items@1} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"OrderedList"/utf8>>)},
                    {<<"c"/utf8>>, encode_ordered_list_content(Attrs, Items@1)}]
            );

        {block_quote, Content@4} ->
            gleam@json:object(
                [{<<"t"/utf8>>, gleam@json:string(<<"BlockQuote"/utf8>>)},
                    {<<"c"/utf8>>,
                        gleam@json:array(Content@4, fun encode_block/1)}]
            )
    end.

-file("src/pandi/encode.gleam", 19).
-spec encode_meta_value(binary()) -> gleam@json:json().
encode_meta_value(Val) ->
    gleam@json:object(
        [{<<"t"/utf8>>, gleam@json:string(<<"pd.MetaInlines"/utf8>>)},
            {<<"c"/utf8>>, gleam@json:array([{str, Val}], fun encode_inline/1)}]
    ).

-file("src/pandi/encode.gleam", 13).
-spec encode_meta(list({binary(), binary()})) -> gleam@json:json().
encode_meta(Meta) ->
    _pipe = Meta,
    _pipe@1 = gleam@list:map(
        _pipe,
        fun(Pair) ->
            {erlang:element(1, Pair),
                encode_meta_value(erlang:element(2, Pair))}
        end
    ),
    gleam@json:object(_pipe@1).

-file("src/pandi/encode.gleam", 5).
-spec encode_document(pandi@pandoc:document()) -> gleam@json:json().
encode_document(Doc) ->
    gleam@json:object(
        [{<<"pandoc-api-version"/utf8>>,
                gleam@json:array([1, 23, 1], fun gleam@json:int/1)},
            {<<"meta"/utf8>>, encode_meta(erlang:element(3, Doc))},
            {<<"blocks"/utf8>>,
                gleam@json:array(erlang:element(2, Doc), fun encode_block/1)}]
    ).
