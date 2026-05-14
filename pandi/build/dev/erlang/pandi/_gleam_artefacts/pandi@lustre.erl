-module(pandi@lustre).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/lustre.gleam").
-export([block_to_lustre/1, blocks_to_lustre/1, to_lustre/1, inline_to_lustre/1, inlines_to_lustre/1, blocks_to_lustre_with/4, to_lustre_with/3, inlines_to_lustre_with/3]).

-file("src/pandi/lustre.gleam", 220).
-spec list_attributes_to_lustre(pandi@pandoc:list_attributes()) -> list(lustre@vdom@vattr:attribute(any())).
list_attributes_to_lustre(Attrs) ->
    Start = lustre@attribute:attribute(
        <<"start"/utf8>>,
        erlang:integer_to_binary(erlang:element(2, Attrs))
    ),
    Type_ = case erlang:element(3, Attrs) of
        decimal ->
            lustre@attribute:attribute(<<"type"/utf8>>, <<"1"/utf8>>);

        lower_alpha ->
            lustre@attribute:attribute(<<"type"/utf8>>, <<"a"/utf8>>);

        upper_alpha ->
            lustre@attribute:attribute(<<"type"/utf8>>, <<"A"/utf8>>);

        lower_roman ->
            lustre@attribute:attribute(<<"type"/utf8>>, <<"i"/utf8>>);

        upper_roman ->
            lustre@attribute:attribute(<<"type"/utf8>>, <<"I"/utf8>>)
    end,
    [Start, Type_].

-file("src/pandi/lustre.gleam", 204).
-spec attributes_to_lustre(pandi@pandoc:attributes()) -> list(lustre@vdom@vattr:attribute(any())).
attributes_to_lustre(Attrs) ->
    Id@1 = case erlang:element(2, Attrs) of
        <<""/utf8>> ->
            [];

        Id ->
            [lustre@attribute:id(Id)]
    end,
    Classes@1 = case erlang:element(3, Attrs) of
        [] ->
            [];

        Classes ->
            [lustre@attribute:class(gleam@string:join(Classes, <<" "/utf8>>))]
    end,
    Keyvalues = gleam@list:map(
        erlang:element(4, Attrs),
        fun(Kv) ->
            lustre@attribute:attribute(
                erlang:element(1, Kv),
                erlang:element(2, Kv)
            )
        end
    ),
    lists:append([Id@1, Classes@1, Keyvalues]).

-file("src/pandi/lustre.gleam", 151).
-spec inline_to_lustre_with(
    pandi@pandoc:inline(),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIM))),
    list({binary(), binary()})
) -> lustre@vdom@vnode:element(DIM).
inline_to_lustre_with(Inline, Inline_renderer, Meta) ->
    case Inline_renderer(Inline, Meta) of
        {some, El} ->
            El;

        none ->
            case Inline of
                {str, Content} ->
                    lustre@element@html:text(Content);

                space ->
                    lustre@element@html:text(<<" "/utf8>>);

                line_break ->
                    lustre@element@html:br([]);

                soft_break ->
                    lustre@element@html:text(<<" "/utf8>>);

                {emph, Content@1} ->
                    Inlines = gleam@list:map(
                        Content@1,
                        fun(_capture) ->
                            inline_to_lustre_with(
                                _capture,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element@html:em([], Inlines);

                {strong, Content@2} ->
                    Inlines@1 = gleam@list:map(
                        Content@2,
                        fun(_capture@1) ->
                            inline_to_lustre_with(
                                _capture@1,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element@html:strong([], Inlines@1);

                {strikeout, Content@3} ->
                    Inlines@2 = gleam@list:map(
                        Content@3,
                        fun(_capture@2) ->
                            inline_to_lustre_with(
                                _capture@2,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element@html:del([], Inlines@2);

                {code, Attrs, Text} ->
                    Attributes = attributes_to_lustre(Attrs),
                    lustre@element@html:code(
                        Attributes,
                        [lustre@element@html:text(Text)]
                    );

                {span, Attrs@1, Content@4} ->
                    Inlines@3 = gleam@list:map(
                        Content@4,
                        fun(_capture@3) ->
                            inline_to_lustre_with(
                                _capture@3,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    Attributes@1 = attributes_to_lustre(Attrs@1),
                    lustre@element@html:span(Attributes@1, Inlines@3);

                {link, Attrs@2, Content@5, Target} ->
                    Inlines@4 = gleam@list:map(
                        Content@5,
                        fun(_capture@4) ->
                            inline_to_lustre_with(
                                _capture@4,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    Attributes@2 = attributes_to_lustre(Attrs@2),
                    Href = lustre@attribute:href(erlang:element(2, Target)),
                    Title@1 = case erlang:element(3, Target) of
                        <<""/utf8>> ->
                            [];

                        Title ->
                            [lustre@attribute:title(Title)]
                    end,
                    lustre@element@html:a(
                        lists:append([Attributes@2, [Href], Title@1]),
                        Inlines@4
                    )
            end
    end.

-file("src/pandi/lustre.gleam", 234).
-spec list_items_to_lustre(
    list(list(pandi@pandoc:block())),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIX))),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIX))),
    list({binary(), binary()})
) -> list(lustre@vdom@vnode:element(DIX)).
list_items_to_lustre(Items, Block_renderer, Inline_renderer, Meta) ->
    gleam@list:map(
        Items,
        fun(Item) ->
            Blocks = gleam@list:map(
                Item,
                fun(_capture) ->
                    block_to_lustre_with(
                        _capture,
                        Block_renderer,
                        Inline_renderer,
                        Meta
                    )
                end
            ),
            lustre@element@html:li([], Blocks)
        end
    ).

-file("src/pandi/lustre.gleam", 77).
-spec block_to_lustre_with(
    pandi@pandoc:block(),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DII))),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DII))),
    list({binary(), binary()})
) -> lustre@vdom@vnode:element(DII).
block_to_lustre_with(Block, Block_renderer, Inline_renderer, Meta) ->
    case Block_renderer(Block, Meta) of
        {some, El} ->
            El;

        none ->
            case Block of
                {header, Level, Attrs, Content} ->
                    Inlines = gleam@list:map(
                        Content,
                        fun(_capture) ->
                            inline_to_lustre_with(
                                _capture,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    Attrs@1 = attributes_to_lustre(Attrs),
                    case Level of
                        1 ->
                            lustre@element@html:h1(Attrs@1, Inlines);

                        2 ->
                            lustre@element@html:h2(Attrs@1, Inlines);

                        3 ->
                            lustre@element@html:h3(Attrs@1, Inlines);

                        4 ->
                            lustre@element@html:h4(Attrs@1, Inlines);

                        5 ->
                            lustre@element@html:h5(Attrs@1, Inlines);

                        6 ->
                            lustre@element@html:h6(Attrs@1, Inlines);

                        _ ->
                            lustre@element@html:h1(Attrs@1, Inlines)
                    end;

                {para, Content@1} ->
                    Inlines@1 = gleam@list:map(
                        Content@1,
                        fun(_capture@1) ->
                            inline_to_lustre_with(
                                _capture@1,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element@html:p([], Inlines@1);

                {plain, Content@2} ->
                    Inlines@2 = gleam@list:map(
                        Content@2,
                        fun(_capture@2) ->
                            inline_to_lustre_with(
                                _capture@2,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element:fragment(Inlines@2);

                {'div', Attrs@2, Content@3} ->
                    Blocks = gleam@list:map(
                        Content@3,
                        fun(_capture@3) ->
                            block_to_lustre_with(
                                _capture@3,
                                Block_renderer,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    Attributes = attributes_to_lustre(Attrs@2),
                    lustre@element@html:'div'(Attributes, Blocks);

                {bullet_list, Items} ->
                    List_items = list_items_to_lustre(
                        Items,
                        Block_renderer,
                        Inline_renderer,
                        Meta
                    ),
                    lustre@element@html:ul([], List_items);

                {code_block, Attrs@3, Text} ->
                    Attributes@1 = attributes_to_lustre(Attrs@3),
                    lustre@element@html:pre(
                        Attributes@1,
                        [lustre@element@html:code(
                                [],
                                [lustre@element@html:text(Text)]
                            )]
                    );

                {ordered_list, Attrs@4, Items@1} ->
                    List_items@1 = list_items_to_lustre(
                        Items@1,
                        Block_renderer,
                        Inline_renderer,
                        Meta
                    ),
                    Attributes@2 = list_attributes_to_lustre(Attrs@4),
                    lustre@element@html:ol(Attributes@2, List_items@1);

                {block_quote, Content@4} ->
                    Blocks@1 = gleam@list:map(
                        Content@4,
                        fun(_capture@4) ->
                            block_to_lustre_with(
                                _capture@4,
                                Block_renderer,
                                Inline_renderer,
                                Meta
                            )
                        end
                    ),
                    lustre@element@html:blockquote([], Blocks@1)
            end
    end.

-file("src/pandi/lustre.gleam", 25).
-spec block_to_lustre(pandi@pandoc:block()) -> lustre@vdom@vnode:element(any()).
block_to_lustre(Block) ->
    block_to_lustre_with(
        Block,
        fun(_, _) -> none end,
        fun(_, _) -> none end,
        []
    ).

-file("src/pandi/lustre.gleam", 20).
-spec blocks_to_lustre(list(pandi@pandoc:block())) -> lustre@vdom@vnode:element(any()).
blocks_to_lustre(Blocks) ->
    Elements = gleam@list:map(Blocks, fun block_to_lustre/1),
    lustre@element:fragment(Elements).

-file("src/pandi/lustre.gleam", 16).
-spec to_lustre(pandi@pandoc:document()) -> lustre@vdom@vnode:element(any()).
to_lustre(Document) ->
    blocks_to_lustre(erlang:element(2, Document)).

-file("src/pandi/lustre.gleam", 34).
-spec inline_to_lustre(pandi@pandoc:inline()) -> lustre@vdom@vnode:element(any()).
inline_to_lustre(Inline) ->
    inline_to_lustre_with(Inline, fun(_, _) -> none end, []).

-file("src/pandi/lustre.gleam", 29).
-spec inlines_to_lustre(list(pandi@pandoc:inline())) -> lustre@vdom@vnode:element(any()).
inlines_to_lustre(Inlines) ->
    Elements = gleam@list:map(Inlines, fun inline_to_lustre/1),
    lustre@element:fragment(Elements).

-file("src/pandi/lustre.gleam", 51).
-spec blocks_to_lustre_with(
    list(pandi@pandoc:block()),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIA))),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIA))),
    list({binary(), binary()})
) -> lustre@vdom@vnode:element(DIA).
blocks_to_lustre_with(Blocks, Block_renderer, Inline_renderer, Meta) ->
    Elements = gleam@list:map(
        Blocks,
        fun(_capture) ->
            block_to_lustre_with(
                _capture,
                Block_renderer,
                Inline_renderer,
                Meta
            )
        end
    ),
    lustre@element:fragment(Elements).

-file("src/pandi/lustre.gleam", 38).
-spec to_lustre_with(
    pandi@pandoc:document(),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DHV))),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DHV)))
) -> lustre@vdom@vnode:element(DHV).
to_lustre_with(Document, Block_renderer, Inline_renderer) ->
    blocks_to_lustre_with(
        erlang:element(2, Document),
        Block_renderer,
        Inline_renderer,
        erlang:element(3, Document)
    ).

-file("src/pandi/lustre.gleam", 67).
-spec inlines_to_lustre_with(
    list(pandi@pandoc:inline()),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(lustre@vdom@vnode:element(DIF))),
    list({binary(), binary()})
) -> lustre@vdom@vnode:element(DIF).
inlines_to_lustre_with(Inlines, Inline_remderer, Meta) ->
    Elements = gleam@list:map(
        Inlines,
        fun(_capture) ->
            inline_to_lustre_with(_capture, Inline_remderer, Meta)
        end
    ),
    lustre@element:fragment(Elements).
