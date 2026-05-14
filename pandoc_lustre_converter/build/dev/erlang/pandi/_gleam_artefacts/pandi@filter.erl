-module(pandi@filter).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/filter.gleam").
-export([filter_blocks/2, filter_inlines/2]).

-file("src/pandi/filter.gleam", 28).
-spec walk_blocks(
    list(pandi@pandoc:block()),
    list({binary(), binary()}),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(list(pandi@pandoc:block())))
) -> list(pandi@pandoc:block()).
walk_blocks(Blocks, Meta, Filter) ->
    gleam@list:flat_map(Blocks, fun(Block) -> case Filter(Block, Meta) of
                {some, New_blocks} ->
                    New_blocks;

                none ->
                    case Block of
                        {'div', Attrs, Content} ->
                            [{'div', Attrs, walk_blocks(Content, Meta, Filter)}];

                        {bullet_list, Items} ->
                            [{bullet_list,
                                    gleam@list:map(
                                        Items,
                                        fun(_capture) ->
                                            walk_blocks(_capture, Meta, Filter)
                                        end
                                    )}];

                        _ ->
                            [Block]
                    end
            end end).

-file("src/pandi/filter.gleam", 11).
-spec filter_blocks(
    pandi@pandoc:document(),
    fun((pandi@pandoc:block(), list({binary(), binary()})) -> gleam@option:option(list(pandi@pandoc:block())))
) -> pandi@pandoc:document().
filter_blocks(Document, Filter) ->
    New_blocks = walk_blocks(
        erlang:element(2, Document),
        erlang:element(3, Document),
        Filter
    ),
    {document, New_blocks, erlang:element(3, Document)}.

-file("src/pandi/filter.gleam", 71).
-spec walk_inlines(
    list(pandi@pandoc:inline()),
    list({binary(), binary()}),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(list(pandi@pandoc:inline())))
) -> list(pandi@pandoc:inline()).
walk_inlines(Inlines, Meta, Filter) ->
    gleam@list:flat_map(Inlines, fun(Inline) -> case Filter(Inline, Meta) of
                {some, New_inlines} ->
                    New_inlines;

                none ->
                    case Inline of
                        {emph, Content} ->
                            [{emph, walk_inlines(Content, Meta, Filter)}];

                        {strong, Content@1} ->
                            [{strong, walk_inlines(Content@1, Meta, Filter)}];

                        {strikeout, Content@2} ->
                            [{strikeout, walk_inlines(Content@2, Meta, Filter)}];

                        {span, Attrs, Content@3} ->
                            [{span,
                                    Attrs,
                                    walk_inlines(Content@3, Meta, Filter)}];

                        {link, Attrs@1, Content@4, Target} ->
                            [{link,
                                    Attrs@1,
                                    walk_inlines(Content@4, Meta, Filter),
                                    Target}];

                        _ ->
                            [Inline]
                    end
            end end).

-file("src/pandi/filter.gleam", 51).
-spec walk_inlines_in_block(
    pandi@pandoc:block(),
    list({binary(), binary()}),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(list(pandi@pandoc:inline())))
) -> pandi@pandoc:block().
walk_inlines_in_block(Block, Meta, Filter) ->
    case Block of
        {header, Level, Attrs, Content} ->
            {header, Level, Attrs, walk_inlines(Content, Meta, Filter)};

        {para, Content@1} ->
            {para, walk_inlines(Content@1, Meta, Filter)};

        {plain, Content@2} ->
            {plain, walk_inlines(Content@2, Meta, Filter)};

        {'div', Attrs@1, Content@3} ->
            {'div',
                Attrs@1,
                gleam@list:map(
                    Content@3,
                    fun(_capture) ->
                        walk_inlines_in_block(_capture, Meta, Filter)
                    end
                )};

        {bullet_list, Items} ->
            {bullet_list,
                gleam@list:map(
                    Items,
                    fun(_capture@1) ->
                        gleam@list:map(
                            _capture@1,
                            fun(_capture@2) ->
                                walk_inlines_in_block(_capture@2, Meta, Filter)
                            end
                        )
                    end
                )};

        _ ->
            Block
    end.

-file("src/pandi/filter.gleam", 19).
-spec filter_inlines(
    pandi@pandoc:document(),
    fun((pandi@pandoc:inline(), list({binary(), binary()})) -> gleam@option:option(list(pandi@pandoc:inline())))
) -> pandi@pandoc:document().
filter_inlines(Document, Filter) ->
    New_blocks = gleam@list:map(
        erlang:element(2, Document),
        fun(_capture) ->
            walk_inlines_in_block(_capture, erlang:element(3, Document), Filter)
        end
    ),
    {document, New_blocks, erlang:element(3, Document)}.
