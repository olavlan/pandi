-module(html_lustre_converter).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/html_lustre_converter.gleam").
-export_type([whitespace_mode/0, output_mode/0]).

-type whitespace_mode() :: preserve_whitespace | strip_whitespace.

-type output_mode() :: svg | html.

-file("src/html_lustre_converter.gleam", 509).
-spec wrap(list(glam@doc:document()), binary(), binary()) -> glam@doc:document().
wrap(Items, Open, Close) ->
    Comma = glam@doc:concat(
        [glam@doc:from_string(<<","/utf8>>), {break, <<" "/utf8>>, <<""/utf8>>}]
    ),
    Open@1 = glam@doc:concat(
        [glam@doc:from_string(Open), {break, <<""/utf8>>, <<""/utf8>>}]
    ),
    Trailing_comma = glam@doc:break(<<""/utf8>>, <<","/utf8>>),
    Close@1 = glam@doc:concat([Trailing_comma, glam@doc:from_string(Close)]),
    _pipe = Items,
    _pipe@1 = glam@doc:join(_pipe, Comma),
    _pipe@2 = glam@doc:prepend(_pipe@1, Open@1),
    _pipe@3 = glam@doc:nest(_pipe@2, 2),
    _pipe@4 = glam@doc:append(_pipe@3, Close@1),
    glam@doc:group(_pipe@4).

-file("src/html_lustre_converter.gleam", 66).
-spec print_string(binary()) -> binary().
print_string(T) ->
    String = begin
        _pipe = T,
        _pipe@1 = gleam@string:replace(_pipe, <<"\\"/utf8>>, <<"\\\\"/utf8>>),
        gleam@string:replace(_pipe@1, <<"\""/utf8>>, <<"\\\""/utf8>>)
    end,
    <<<<"\""/utf8, String/binary>>/binary, "\""/utf8>>.

-file("src/html_lustre_converter.gleam", 62).
-spec print_text(binary()) -> glam@doc:document().
print_text(T) ->
    glam@doc:from_string(
        <<<<"html.text("/utf8, (print_string(T))/binary>>/binary, ")"/utf8>>
    ).

-file("src/html_lustre_converter.gleam", 349).
-spec get_text_content(list(javascript_dom_parser:html_node())) -> binary().
get_text_content(Nodes) ->
    _pipe = gleam@list:filter_map(Nodes, fun(Node) -> case Node of
                {text, T} ->
                    {ok, T};

                _ ->
                    {error, nil}
            end end),
    erlang:list_to_binary(_pipe).

-file("src/html_lustre_converter.gleam", 421).
-spec print_attribute({binary(), binary()}, output_mode()) -> glam@doc:document().
print_attribute(Attribute, Mode) ->
    case erlang:element(1, Attribute) of
        <<"action"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"alt"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"attribute"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"autocomplete"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"charset"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"class"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"content"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"download"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"enctype"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"for"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"form_action"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"form_enctype"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"form_method"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"form_target"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"href"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"id"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"map"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"max"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"method"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"min"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"msg"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"name"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"none"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"on"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"pattern"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"placeholder"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"rel"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"role"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"src"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"step"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"target"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"value"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"wrap"/utf8>> ->
            glam@doc:from_string(
                <<<<<<<<"attribute."/utf8,
                                (erlang:element(1, Attribute))/binary>>/binary,
                            "("/utf8>>/binary,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"viewbox"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute(\"viewBox\", "/utf8,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"type"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute.type_("/utf8,
                        (print_string(erlang:element(2, Attribute)))/binary>>/binary,
                    ")"/utf8>>
            );

        <<"checked"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"controls"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"disabled"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"form_novalidate"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"loop"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"novalidate"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"readonly"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"required"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"selected"/utf8>> ->
            glam@doc:from_string(
                <<<<"attribute."/utf8, (erlang:element(1, Attribute))/binary>>/binary,
                    "(True)"/utf8>>
            );

        <<"width"/utf8>> ->
            case Mode of
                svg ->
                    Children = [glam@doc:from_string(
                            print_string(erlang:element(1, Attribute))
                        ),
                        glam@doc:from_string(
                            print_string(erlang:element(2, Attribute))
                        )],
                    _pipe = glam@doc:from_string(<<"attribute"/utf8>>),
                    glam@doc:append(
                        _pipe,
                        wrap(Children, <<"("/utf8>>, <<")"/utf8>>)
                    );

                html ->
                    glam@doc:from_string(
                        <<<<<<<<"attribute."/utf8,
                                        (erlang:element(1, Attribute))/binary>>/binary,
                                    "("/utf8>>/binary,
                                (erlang:element(2, Attribute))/binary>>/binary,
                            ")"/utf8>>
                    )
            end;

        <<"height"/utf8>> ->
            case Mode of
                svg ->
                    Children = [glam@doc:from_string(
                            print_string(erlang:element(1, Attribute))
                        ),
                        glam@doc:from_string(
                            print_string(erlang:element(2, Attribute))
                        )],
                    _pipe = glam@doc:from_string(<<"attribute"/utf8>>),
                    glam@doc:append(
                        _pipe,
                        wrap(Children, <<"("/utf8>>, <<")"/utf8>>)
                    );

                html ->
                    glam@doc:from_string(
                        <<<<<<<<"attribute."/utf8,
                                        (erlang:element(1, Attribute))/binary>>/binary,
                                    "("/utf8>>/binary,
                                (erlang:element(2, Attribute))/binary>>/binary,
                            ")"/utf8>>
                    )
            end;

        <<"cols"/utf8>> ->
            case Mode of
                svg ->
                    Children = [glam@doc:from_string(
                            print_string(erlang:element(1, Attribute))
                        ),
                        glam@doc:from_string(
                            print_string(erlang:element(2, Attribute))
                        )],
                    _pipe = glam@doc:from_string(<<"attribute"/utf8>>),
                    glam@doc:append(
                        _pipe,
                        wrap(Children, <<"("/utf8>>, <<")"/utf8>>)
                    );

                html ->
                    glam@doc:from_string(
                        <<<<<<<<"attribute."/utf8,
                                        (erlang:element(1, Attribute))/binary>>/binary,
                                    "("/utf8>>/binary,
                                (erlang:element(2, Attribute))/binary>>/binary,
                            ")"/utf8>>
                    )
            end;

        <<"rows"/utf8>> ->
            case Mode of
                svg ->
                    Children = [glam@doc:from_string(
                            print_string(erlang:element(1, Attribute))
                        ),
                        glam@doc:from_string(
                            print_string(erlang:element(2, Attribute))
                        )],
                    _pipe = glam@doc:from_string(<<"attribute"/utf8>>),
                    glam@doc:append(
                        _pipe,
                        wrap(Children, <<"("/utf8>>, <<")"/utf8>>)
                    );

                html ->
                    glam@doc:from_string(
                        <<<<<<<<"attribute."/utf8,
                                        (erlang:element(1, Attribute))/binary>>/binary,
                                    "("/utf8>>/binary,
                                (erlang:element(2, Attribute))/binary>>/binary,
                            ")"/utf8>>
                    )
            end;

        _ ->
            Children@1 = [glam@doc:from_string(
                    print_string(erlang:element(1, Attribute))
                ),
                glam@doc:from_string(print_string(erlang:element(2, Attribute)))],
            _pipe@1 = glam@doc:from_string(<<"attribute"/utf8>>),
            glam@doc:append(
                _pipe@1,
                wrap(Children@1, <<"("/utf8>>, <<")"/utf8>>)
            )
    end.

-file("src/html_lustre_converter.gleam", 185).
-spec print_element(
    binary(),
    list({binary(), binary()}),
    list(javascript_dom_parser:html_node()),
    whitespace_mode()
) -> glam@doc:document().
print_element(Tag, Given_attributes, Children, Ws) ->
    Tag@1 = string:lowercase(Tag),
    Attributes = begin
        _pipe = gleam@list:map(
            Given_attributes,
            fun(A) -> print_attribute(A, html) end
        ),
        wrap(_pipe, <<"["/utf8>>, <<"]"/utf8>>)
    end,
    case Tag@1 of
        <<"area"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"base"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"br"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"col"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"embed"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"hr"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"iframe"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"img"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"input"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"link"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"meta"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"param"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"source"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"track"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"wbr"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"html."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"a"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"abbr"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"address"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"article"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"aside"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"audio"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"b"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"bdi"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"bdo"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"blockquote"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"body"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"button"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"canvas"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"caption"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"cite"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"code"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"colgroup"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"data"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"datalist"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"dd"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"del"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"details"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"dfn"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"dialog"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"div"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"dl"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"dt"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"em"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"fieldset"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"figcaption"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"figure"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"footer"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"form"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h1"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h2"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h3"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h4"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h5"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"h6"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"head"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"header"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"hgroup"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"html"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"i"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"ins"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"kbd"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"label"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"legend"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"li"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"main"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"map"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"mark"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"math"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"menu"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"meter"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"nav"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"noscript"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"object"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"ol"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"optgroup"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"output"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"p"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"picture"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"portal"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"progress"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"q"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"rp"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"rt"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"ruby"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"s"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"samp"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"search"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"section"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"select"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"slot"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"small"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"span"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"strong"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"sub"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"summary"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"sup"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"table"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"tbody"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"td"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"template"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"text"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"tfoot"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"th"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"thead"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"time"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"tr"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"u"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"ul"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"var"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"video"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@3 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"svg"/utf8>> ->
            Attributes@1 = begin
                _pipe@4 = gleam@list:map(
                    Given_attributes,
                    fun(A@1) -> print_attribute(A@1, svg) end
                ),
                wrap(_pipe@4, <<"["/utf8>>, <<"]"/utf8>>)
            end,
            Children@2 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@5 = glam@doc:from_string(<<"svg.svg"/utf8>>),
            glam@doc:append(
                _pipe@5,
                wrap([Attributes@1, Children@2], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"pre"/utf8>> ->
            Children@3 = wrap(
                print_children(Children, preserve_whitespace, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes, Children@3], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"script"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@7 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@7,
                wrap([Attributes, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"style"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@7 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@7,
                wrap([Attributes, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"textarea"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@7 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@7,
                wrap([Attributes, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"title"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@7 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@7,
                wrap([Attributes, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"option"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@7 = glam@doc:from_string(<<"html."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@7,
                wrap([Attributes, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        _ ->
            Children@4 = wrap(
                print_children(Children, Ws, html),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            Tag@2 = glam@doc:from_string(print_string(Tag@1)),
            _pipe@8 = glam@doc:from_string(<<"element"/utf8>>),
            glam@doc:append(
                _pipe@8,
                wrap(
                    [Tag@2, Attributes, Children@4],
                    <<"("/utf8>>,
                    <<")"/utf8>>
                )
            )
    end.

-file("src/html_lustre_converter.gleam", 74).
-spec print_svg_element(
    binary(),
    list({binary(), binary()}),
    list(javascript_dom_parser:html_node()),
    whitespace_mode()
) -> glam@doc:document().
print_svg_element(Tag, Attributes, Children, Ws) ->
    Tag@1 = string:lowercase(Tag),
    Attributes@1 = begin
        _pipe = gleam@list:map(
            Attributes,
            fun(A) -> print_attribute(A, svg) end
        ),
        wrap(_pipe, <<"["/utf8>>, <<"]"/utf8>>)
    end,
    case Tag@1 of
        <<"animate"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"animatemotion"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"animatetransform"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"mpath"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"set"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"circle"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"ellipse"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"line"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"polygon"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"polyline"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"rect"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feblend"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fecolormatrix"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fecomponenttransfer"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fecomposite"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feconvolvematrix"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fedisplacementmap"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fedropshadow"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feflood"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fefunca"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fefuncb"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fefuncg"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fefuncr"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fegaussianblur"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feimage"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"femergenode"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"femorphology"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feoffset"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"feturbulance"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"stop"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"image"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"path"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fedistantlight"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fepointlight"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"fespotlight"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"title"/utf8>> ->
            _pipe@1 = glam@doc:from_string(
                <<<<"svg."/utf8, Tag@1/binary>>/binary, "("/utf8>>
            ),
            _pipe@2 = glam@doc:append(_pipe@1, Attributes@1),
            glam@doc:append(_pipe@2, glam@doc:from_string(<<")"/utf8>>));

        <<"textarea"/utf8>> ->
            Content = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@3 = glam@doc:from_string(<<"text."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@3,
                wrap([Attributes@1, Content], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"text"/utf8>> ->
            Content@1 = glam@doc:from_string(
                print_string(get_text_content(Children))
            ),
            _pipe@4 = glam@doc:from_string(<<"svg."/utf8, Tag@1/binary>>),
            glam@doc:append(
                _pipe@4,
                wrap([Attributes@1, Content@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"use"/utf8>> ->
            _pipe@5 = glam@doc:from_string(<<"svg.use_"/utf8>>),
            glam@doc:append(_pipe@5, Attributes@1);

        <<"defs"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"g"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"marker"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"mask"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"missing-glyph"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"pattern"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"switch"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"symbol"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"desc"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"metadata"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"fediffuselighting"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"femerge"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"fespecularlighting"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"fetile"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"lineargradient"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        <<"radialgradient"/utf8>> ->
            Children@1 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            _pipe@6 = glam@doc:from_string(
                <<"svg."/utf8,
                    (gleam@string:replace(Tag@1, <<"-"/utf8>>, <<"_"/utf8>>))/binary>>
            ),
            glam@doc:append(
                _pipe@6,
                wrap([Attributes@1, Children@1], <<"("/utf8>>, <<")"/utf8>>)
            );

        _ ->
            Children@2 = wrap(
                print_children(Children, Ws, svg),
                <<"["/utf8>>,
                <<"]"/utf8>>
            ),
            Tag@2 = glam@doc:from_string(print_string(Tag@1)),
            _pipe@7 = glam@doc:from_string(<<"element"/utf8>>),
            glam@doc:append(
                _pipe@7,
                wrap(
                    [Tag@2, Attributes@1, Children@2],
                    <<"("/utf8>>,
                    <<")"/utf8>>
                )
            )
    end.

-file("src/html_lustre_converter.gleam", 367).
-spec print_children_loop(
    list(javascript_dom_parser:html_node()),
    whitespace_mode(),
    output_mode(),
    list(glam@doc:document())
) -> list(glam@doc:document()).
print_children_loop(In, Ws, Mode, Acc) ->
    case In of
        [] ->
            lists:reverse(Acc);

        [{element, Tag, Attrs, Children} | In@1] when Mode =:= svg ->
            Child = print_svg_element(Tag, Attrs, Children, Ws),
            print_children_loop(In@1, Ws, Mode, [Child | Acc]);

        [{element, Tag@1, Attrs@1, Children@1} | In@2] ->
            Child@1 = print_element(Tag@1, Attrs@1, Children@1, Ws),
            print_children_loop(In@2, Ws, Mode, [Child@1 | Acc]);

        [{comment, _} | In@3] ->
            print_children_loop(In@3, Ws, Mode, Acc);

        [{text, Input} | In@4] when Ws =:= strip_whitespace ->
            Trimmed = gleam@string:trim(Input),
            Trimmed@1 = case Input of
                _ when Trimmed =:= <<""/utf8>> ->
                    Trimmed;

                <<" "/utf8, _/binary>> ->
                    <<" "/utf8, Trimmed/binary>>;

                <<"\t"/utf8, _/binary>> ->
                    <<" "/utf8, Trimmed/binary>>;

                <<"\n"/utf8, _/binary>> ->
                    <<" "/utf8, Trimmed/binary>>;

                _ ->
                    Trimmed
            end,
            Trimmed@2 = case (Trimmed@1 /= <<""/utf8>>) andalso ((gleam_stdlib:string_ends_with(
                Input,
                <<" "/utf8>>
            )
            orelse gleam_stdlib:string_ends_with(Input, <<"\n"/utf8>>))
            orelse gleam_stdlib:string_ends_with(Input, <<"\t"/utf8>>)) of
                true ->
                    <<Trimmed@1/binary, " "/utf8>>;

                false ->
                    Trimmed@1
            end,
            case Trimmed@2 of
                <<""/utf8>> ->
                    print_children_loop(In@4, Ws, Mode, Acc);

                T ->
                    print_children_loop(In@4, Ws, Mode, [print_text(T) | Acc])
            end;

        [{text, T@1} | In@5] ->
            print_children_loop(In@5, Ws, Mode, [print_text(T@1) | Acc])
    end.

-file("src/html_lustre_converter.gleam", 359).
-spec print_children(
    list(javascript_dom_parser:html_node()),
    whitespace_mode(),
    output_mode()
) -> list(glam@doc:document()).
print_children(Children, Ws, Mode) ->
    print_children_loop(Children, Ws, Mode, []).

-file("src/html_lustre_converter.gleam", 52).
-spec strip_body_wrapper(javascript_dom_parser:html_node(), binary()) -> list(javascript_dom_parser:html_node()).
strip_body_wrapper(Html, Source) ->
    Full_page = gleam_stdlib:contains_string(Source, <<"<head>"/utf8>>),
    case Html of
        {element,
            <<"HTML"/utf8>>,
            [],
            [{element, <<"HEAD"/utf8>>, [], []},
                {element, <<"BODY"/utf8>>, [], Nodes}]} when not Full_page ->
            Nodes;

        _ ->
            [Html]
    end.
