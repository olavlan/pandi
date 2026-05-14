-module(birdie@internal@analyser).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/birdie/internal/analyser.gleam").
-export([new/0, remove_module/2, errors/1, warnings/1, get_snapshot_tests/2, analyse/2, error_to_diagnostic/1]).
-export_type([analyser/0, error/0, warning/0, module_/0, analysed_module/0, snapshot_test/0, snapshot_title/0, snap_usage/0, scope/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-opaque analyser() :: {analyser,
        gleam@dict:dict(gleam@uri:uri(), analysed_module()),
        gleam@dict:dict(binary(), gleam@dict:dict(gleam@uri:uri(), list(snapshot_test())))}.

-type error() :: {title_already_in_use,
        analysed_module(),
        glance:span(),
        glance:span()}.

-type warning() :: {non_literal_title, analysed_module(), glance:span()}.

-type module_() :: {module, gleam@uri:uri(), binary()}.

-type analysed_module() :: {analysed_module,
        gleam@uri:uri(),
        binary(),
        list(snapshot_test())}.

-type snapshot_test() :: {snapshot_test,
        snapshot_title(),
        glance:span(),
        glance:span(),
        binary(),
        glance:span()}.

-type snapshot_title() :: {literal_title, binary()} | expression_title.

-type snap_usage() :: {only_qualified, binary()} |
    {qualified_and_unqualified, binary(), binary()} |
    {only_unqualified, binary()}.

-type scope() :: {scope, gleam@set:set(binary())}.

-file("src/birdie/internal/analyser.gleam", 125).
?DOC(false).
-spec new() -> analyser().
new() ->
    {analyser, maps:new(), maps:new()}.

-file("src/birdie/internal/analyser.gleam", 153).
?DOC(false).
-spec remove_snapshot_title(
    snapshot_test(),
    analysed_module(),
    gleam@dict:dict(binary(), gleam@dict:dict(gleam@uri:uri(), list(snapshot_test())))
) -> gleam@dict:dict(binary(), gleam@dict:dict(gleam@uri:uri(), list(snapshot_test()))).
remove_snapshot_title(Snapshot, Module, Names) ->
    case erlang:element(2, Snapshot) of
        expression_title ->
            Names;

        {literal_title, Title} ->
            case gleam_stdlib:map_get(Names, Title) of
                {error, _} ->
                    Names;

                {ok, Module_to_spans} ->
                    Module_to_spans@1 = gleam@dict:delete(
                        Module_to_spans,
                        erlang:element(2, Module)
                    ),
                    gleam@dict:insert(Names, Title, Module_to_spans@1)
            end
    end.

-file("src/birdie/internal/analyser.gleam", 129).
?DOC(false).
-spec remove_module(analyser(), gleam@uri:uri()) -> analyser().
remove_module(Analyser, Module) ->
    {analyser, Modules, Literal_titles} = Analyser,
    case gleam_stdlib:map_get(Modules, Module) of
        {error, _} ->
            Analyser;

        {ok, Module@1} ->
            Modules@1 = gleam@dict:delete(Modules, erlang:element(2, Module@1)),
            Literal_titles@1 = gleam@list:fold(
                erlang:element(4, Module@1),
                Literal_titles,
                fun(Names, Snapshot) ->
                    remove_snapshot_title(Snapshot, Module@1, Names)
                end
            ),
            {analyser, Modules@1, Literal_titles@1}
    end.

-file("src/birdie/internal/analyser.gleam", 174).
?DOC(false).
-spec errors(analyser()) -> list(error()).
errors(Analyser) ->
    gleam@dict:fold(
        erlang:element(3, Analyser),
        [],
        fun(Acc, _, Snapshots) ->
            Errors = gleam@dict:fold(
                Snapshots,
                [],
                fun(Acc@1, Module, Snapshots@1) ->
                    gleam@list:fold(
                        Snapshots@1,
                        Acc@1,
                        fun(Acc@2, Snapshot) ->
                            case gleam_stdlib:map_get(
                                erlang:element(2, Analyser),
                                Module
                            ) of
                                {error, _} ->
                                    Acc@2;

                                {ok, Module@1} ->
                                    [{title_already_in_use,
                                            Module@1,
                                            erlang:element(6, Snapshot),
                                            erlang:element(3, Snapshot)} |
                                        Acc@2]
                            end
                        end
                    )
                end
            ),
            case Errors of
                [] ->
                    Acc;

                [_] ->
                    Acc;

                [_, _ | _] ->
                    _pipe = Errors,
                    lists:append(_pipe, Acc)
            end
        end
    ).

-file("src/birdie/internal/analyser.gleam", 202).
?DOC(false).
-spec warnings(analyser()) -> list(warning()).
warnings(Analyser) ->
    gleam@dict:fold(
        erlang:element(2, Analyser),
        [],
        fun(Acc, _, Module) ->
            gleam@list:fold(
                erlang:element(4, Module),
                Acc,
                fun(Acc@1, Snapshot) -> case erlang:element(2, Snapshot) of
                        {literal_title, _} ->
                            Acc@1;

                        expression_title ->
                            [{non_literal_title,
                                    Module,
                                    erlang:element(3, Snapshot)} |
                                Acc@1]
                    end end
            )
        end
    ).

-file("src/birdie/internal/analyser.gleam", 224).
?DOC(false).
-spec get_snapshot_tests(analyser(), binary()) -> list({gleam@uri:uri(),
    snapshot_test()}).
get_snapshot_tests(Analyser, Title) ->
    case gleam_stdlib:map_get(erlang:element(3, Analyser), Title) of
        {error, _} ->
            [];

        {ok, Modules} ->
            gleam@dict:fold(
                Modules,
                [],
                fun(Tests, Module, New_tests) ->
                    _pipe = gleam@list:map(
                        New_tests,
                        fun(New_test) -> {Module, New_test} end
                    ),
                    lists:append(_pipe, Tests)
                end
            )
    end.

-file("src/birdie/internal/analyser.gleam", 247).
?DOC(false).
-spec add_analysed_module(analyser(), analysed_module()) -> analyser().
add_analysed_module(Analyser, Module) ->
    {analyser, Modules, Literal_titles} = Analyser,
    Modules@1 = gleam@dict:insert(Modules, erlang:element(2, Module), Module),
    Literal_titles@2 = begin
        _pipe = gleam@list:group(
            erlang:element(4, Module),
            fun(Snapshot) -> erlang:element(2, Snapshot) end
        ),
        gleam@dict:fold(
            _pipe,
            Literal_titles,
            fun(Literal_titles@1, Title, Snapshots) -> case Title of
                    expression_title ->
                        Literal_titles@1;

                    {literal_title, Title@1} ->
                        gleam@dict:upsert(
                            Literal_titles@1,
                            Title@1,
                            fun(References) -> case References of
                                    none ->
                                        maps:from_list(
                                            [{erlang:element(2, Module),
                                                    Snapshots}]
                                        );

                                    {some, References@1} ->
                                        gleam@dict:insert(
                                            References@1,
                                            erlang:element(2, Module),
                                            Snapshots
                                        )
                                end end
                        )
                end end
        )
    end,
    {analyser, Modules@1, Literal_titles@2}.

-file("src/birdie/internal/analyser.gleam", 500).
?DOC(false).
-spec expression_to_title(glance:expression()) -> snapshot_title().
expression_to_title(Title) ->
    case Title of
        {string, _, Value} ->
            {literal_title, Value};

        {echo, _, {some, Expression}, _} ->
            expression_to_title(Expression);

        {binary_operator, _, concatenate, Left, Right} ->
            case expression_to_title(Left) of
                expression_title ->
                    expression_title;

                {literal_title, Left@1} ->
                    case expression_to_title(Right) of
                        {literal_title, Right@1} ->
                            {literal_title, <<Left@1/binary, Right@1/binary>>};

                        expression_title ->
                            expression_title
                    end
            end;

        _ ->
            expression_title
    end.

-file("src/birdie/internal/analyser.gleam", 524).
?DOC(false).
-spec is_snap_function(glance:expression(), scope(), snap_usage()) -> boolean().
is_snap_function(Function, Scope, Snap_usage) ->
    case Function of
        {variable, _, Used_snap_name} ->
            case Snap_usage of
                {only_qualified, _} ->
                    false;

                {qualified_and_unqualified, _, Snap_name} ->
                    (Snap_name =:= Used_snap_name) andalso not gleam@set:contains(
                        erlang:element(2, Scope),
                        Snap_name
                    );

                {only_unqualified, Snap_name} ->
                    (Snap_name =:= Used_snap_name) andalso not gleam@set:contains(
                        erlang:element(2, Scope),
                        Snap_name
                    )
            end;

        {field_access, _, {variable, _, Used_module_name}, <<"snap"/utf8>>} ->
            case Snap_usage of
                {only_unqualified, _} ->
                    false;

                {only_qualified, Birdie_name} ->
                    (Used_module_name =:= Birdie_name) andalso not gleam@set:contains(
                        erlang:element(2, Scope),
                        Birdie_name
                    );

                {qualified_and_unqualified, Birdie_name, _} ->
                    (Used_module_name =:= Birdie_name) andalso not gleam@set:contains(
                        erlang:element(2, Scope),
                        Birdie_name
                    )
            end;

        _ ->
            false
    end.

-file("src/birdie/internal/analyser.gleam", 331).
?DOC(false).
-spec snapshot_test(
    snap_usage(),
    scope(),
    binary(),
    glance:span(),
    glance:expression()
) -> {ok, snapshot_test()} | {error, nil}.
snapshot_test(Snap_usage, Scope, Function_name, Function_name_span, Expression) ->
    case Expression of
        {call,
            Call_span,
            Function,
            [{unlabelled_field, Title},
                {labelled_field, <<"content"/utf8>>, _, _}]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {call,
            Call_span,
            Function,
            [{unlabelled_field, _}, {unlabelled_field, Title}]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {call,
            Call_span,
            Function,
            [{unlabelled_field, _},
                {labelled_field, <<"title"/utf8>>, _, Title}]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {call,
            Call_span,
            Function,
            [{labelled_field, <<"content"/utf8>>, _, _},
                {unlabelled_field, Title}]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {call,
            Call_span,
            Function,
            [{labelled_field, <<"content"/utf8>>, _, _},
                {labelled_field, <<"title"/utf8>>, _, Title}]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {call,
            Call_span,
            Function,
            [{labelled_field, <<"title"/utf8>>, _, Title}, _]} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            Title,
            {call, _, Function, [{labelled_field, <<"content"/utf8>>, _, _}]}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            _,
            {call, _, Function, [{unlabelled_field, Title}]}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            _,
            {call, _, Function, [{labelled_field, <<"title"/utf8>>, _, Title}]}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            Title,
            {fn_capture, _, {some, <<"title"/utf8>>}, Function, [_], []}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            Title,
            {fn_capture, _, {some, <<"title"/utf8>>}, Function, [], [_]}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {binary_operator,
            Call_span,
            pipe,
            Title,
            {fn_capture, _, _, Function, [{unlabelled_field, _}], []}} ->
            case is_snap_function(Function, Scope, Snap_usage) of
                false ->
                    {error, nil};

                true ->
                    {ok,
                        {snapshot_test,
                            expression_to_title(Title),
                            erlang:element(2, Title),
                            Call_span,
                            Function_name,
                            Function_name_span}}
            end;

        {echo, _, {some, Expression@1}, _} ->
            snapshot_test(
                Snap_usage,
                Scope,
                Function_name,
                Function_name_span,
                Expression@1
            );

        _ ->
            {error, nil}
    end.

-file("src/birdie/internal/analyser.gleam", 854).
?DOC(false).
-spec pattern_variables(gleam@set:set(binary()), glance:pattern()) -> gleam@set:set(binary()).
pattern_variables(Acc, Pattern) ->
    case Pattern of
        {pattern_int, _, _} ->
            Acc;

        {pattern_float, _, _} ->
            Acc;

        {pattern_string, _, _} ->
            Acc;

        {pattern_discard, _, _} ->
            Acc;

        {pattern_variable, _, Name} ->
            gleam@set:insert(Acc, Name);

        {pattern_tuple, _, Elements} ->
            gleam@list:fold(Elements, Acc, fun pattern_variables/2);

        {pattern_list, _, Elements@1, none} ->
            gleam@list:fold(Elements@1, Acc, fun pattern_variables/2);

        {pattern_list, _, Elements@2, {some, Tail}} ->
            Acc@1 = gleam@list:fold(Elements@2, Acc, fun pattern_variables/2),
            pattern_variables(Acc@1, Tail);

        {pattern_assignment, _, Pattern@1, Name@1} ->
            Acc@2 = gleam@set:insert(Acc, Name@1),
            pattern_variables(Acc@2, Pattern@1);

        {pattern_concatenate, _, _, Prefix_name, Rest_name} ->
            Acc@3 = case Prefix_name of
                {some, {discarded, _}} ->
                    Acc;

                none ->
                    Acc;

                {some, {named, Name@2}} ->
                    gleam@set:insert(Acc, Name@2)
            end,
            case Rest_name of
                {named, Name@3} ->
                    gleam@set:insert(Acc@3, Name@3);

                {discarded, _} ->
                    Acc@3
            end;

        {pattern_bit_string, _, Segments} ->
            gleam@list:fold(
                Segments,
                Acc,
                fun(Acc@4, Segment) ->
                    pattern_variables(Acc@4, erlang:element(1, Segment))
                end
            );

        {pattern_variant, _, _, _, Arguments, _} ->
            gleam@list:fold(
                Arguments,
                Acc,
                fun(Acc@5, Argument) -> case Argument of
                        {shorthand_field, Label, _} ->
                            gleam@set:insert(Acc@5, Label);

                        {labelled_field, _, _, Item} ->
                            pattern_variables(Acc@5, Item);

                        {unlabelled_field, Item} ->
                            pattern_variables(Acc@5, Item)
                    end end
            )
    end.

-file("src/birdie/internal/analyser.gleam", 847).
?DOC(false).
-spec update_scope_from_patterns(scope(), list(glance:pattern())) -> scope().
update_scope_from_patterns(Scope, Patterns) ->
    {scope,
        gleam@list:fold(
            Patterns,
            erlang:element(2, Scope),
            fun pattern_variables/2
        )}.

-file("src/birdie/internal/analyser.gleam", 815).
?DOC(false).
-spec fold_clauses(
    list(glance:clause()),
    scope(),
    GHS,
    fun((GHS, scope(), glance:expression()) -> GHS)
) -> GHS.
fold_clauses(Clauses, Scope, Acc, Fun) ->
    gleam@list:fold(Clauses, Acc, fun(Acc@1, Clause) -> case Clause of
                {clause, Patterns, none, Body} ->
                    Scope@1 = gleam@list:fold(
                        Patterns,
                        Scope,
                        fun update_scope_from_patterns/2
                    ),
                    fold_expression(Body, Scope@1, Acc@1, Fun);

                {clause, Patterns@1, {some, Guard}, Body@1} ->
                    Scope@2 = gleam@list:fold(
                        Patterns@1,
                        Scope,
                        fun update_scope_from_patterns/2
                    ),
                    Acc@2 = fold_expression(Guard, Scope@2, Acc@1, Fun),
                    fold_expression(Body@1, Scope@2, Acc@2, Fun)
            end end).

-file("src/birdie/internal/analyser.gleam", 836).
?DOC(false).
-spec fold_expressions(
    list(glance:expression()),
    scope(),
    GHU,
    fun((GHU, scope(), glance:expression()) -> GHU)
) -> GHU.
fold_expressions(Expressions, Scope, Acc, Fun) ->
    gleam@list:fold(
        Expressions,
        Acc,
        fun(Acc@1, Expression) ->
            fold_expression(Expression, Scope, Acc@1, Fun)
        end
    ).

-file("src/birdie/internal/analyser.gleam", 800).
?DOC(false).
-spec fold_fields(
    list(glance:field(glance:expression())),
    scope(),
    GHQ,
    fun((GHQ, scope(), glance:expression()) -> GHQ)
) -> GHQ.
fold_fields(Fields, Scope, Acc, Fun) ->
    gleam@list:fold(Fields, Acc, fun(Acc@1, Field) -> case Field of
                {labelled_field, _, _, Item} ->
                    fold_expression(Item, Scope, Acc@1, Fun);

                {unlabelled_field, Item} ->
                    fold_expression(Item, Scope, Acc@1, Fun);

                {shorthand_field, _, _} ->
                    Acc@1
            end end).

-file("src/birdie/internal/analyser.gleam", 709).
?DOC(false).
-spec fold_expression(
    glance:expression(),
    scope(),
    GHN,
    fun((GHN, scope(), glance:expression()) -> GHN)
) -> GHN.
fold_expression(Expression, Scope, Acc, Fun) ->
    Acc@1 = Fun(Acc, Scope, Expression),
    case Expression of
        {echo, _, {some, Expression@1}, none} ->
            fold_expression(Expression@1, Scope, Acc@1, Fun);

        {echo, _, none, {some, Expression@1}} ->
            fold_expression(Expression@1, Scope, Acc@1, Fun);

        {echo, _, {some, Expression@2}, {some, Message}} ->
            Acc@2 = fold_expression(Expression@2, Scope, Acc@1, Fun),
            fold_expression(Message, Scope, Acc@2, Fun);

        {negate_int, _, Expression@3} ->
            fold_expression(Expression@3, Scope, Acc@1, Fun);

        {negate_bool, _, Expression@3} ->
            fold_expression(Expression@3, Scope, Acc@1, Fun);

        {field_access, _, Expression@3, _} ->
            fold_expression(Expression@3, Scope, Acc@1, Fun);

        {tuple_index, _, Expression@3, _} ->
            fold_expression(Expression@3, Scope, Acc@1, Fun);

        {block, _, Statements} ->
            fold_statements(Statements, Scope, Acc@1, Fun);

        {tuple, _, Elements} ->
            fold_expressions(Elements, Scope, Acc@1, Fun);

        {list, _, Elements, none} ->
            fold_expressions(Elements, Scope, Acc@1, Fun);

        {list, _, Elements@1, {some, Rest}} ->
            Acc@3 = fold_expressions(Elements@1, Scope, Acc@1, Fun),
            fold_expression(Rest, Scope, Acc@3, Fun);

        {fn, _, Arguments, _, Statements@1} ->
            Scope@2 = gleam@list:fold(
                Arguments,
                Scope,
                fun(Scope@1, Argument) -> case erlang:element(2, Argument) of
                        {discarded, _} ->
                            Scope@1;

                        {named, Name} ->
                            {scope,
                                gleam@set:insert(
                                    erlang:element(2, Scope@1),
                                    Name
                                )}
                    end end
            ),
            fold_statements(Statements@1, Scope@2, Acc@1, Fun);

        {record_update, _, _, _, Record, Fields} ->
            Acc@4 = fold_expression(Record, Scope, Acc@1, Fun),
            gleam@list:fold(
                Fields,
                Acc@4,
                fun(Acc@5, Field) -> case erlang:element(3, Field) of
                        {some, Item} ->
                            fold_expression(Item, Scope, Acc@5, Fun);

                        none ->
                            Acc@5
                    end end
            );

        {call, _, Function, Arguments@1} ->
            Acc@6 = fold_expression(Function, Scope, Acc@1, Fun),
            fold_fields(Arguments@1, Scope, Acc@6, Fun);

        {fn_capture, _, _, Function@1, Arguments_before, Arguments_after} ->
            Acc@7 = fold_expression(Function@1, Scope, Acc@1, Fun),
            Acc@8 = fold_fields(Arguments_before, Scope, Acc@7, Fun),
            fold_fields(Arguments_after, Scope, Acc@8, Fun);

        {'case', _, Subjects, Clauses} ->
            Acc@9 = fold_expressions(Subjects, Scope, Acc@1, Fun),
            fold_clauses(Clauses, Scope, Acc@9, Fun);

        {binary_operator, _, _, Left, Right} ->
            Acc@10 = fold_expression(Left, Scope, Acc@1, Fun),
            fold_expression(Right, Scope, Acc@10, Fun);

        {panic, _, {some, Expression@4}} ->
            fold_expression(Expression@4, Scope, Acc@1, Fun);

        {todo, _, {some, Expression@4}} ->
            fold_expression(Expression@4, Scope, Acc@1, Fun);

        {panic, _, none} ->
            Acc@1;

        {todo, _, none} ->
            Acc@1;

        {bit_string, _, _} ->
            Acc@1;

        {int, _, _} ->
            Acc@1;

        {float, _, _} ->
            Acc@1;

        {string, _, _} ->
            Acc@1;

        {variable, _, _} ->
            Acc@1;

        {echo, _, none, none} ->
            Acc@1
    end.

-file("src/birdie/internal/analyser.gleam", 658).
?DOC(false).
-spec fold_statements(
    list(glance:statement()),
    scope(),
    GHM,
    fun((GHM, scope(), glance:expression()) -> GHM)
) -> GHM.
fold_statements(Statements, Scope, Acc, Fun) ->
    {_, Acc@6} = gleam@list:fold(
        Statements,
        {Scope, Acc},
        fun(Acc@1, Statement) ->
            {Scope@1, Acc@2} = Acc@1,
            case Statement of
                {use, _, Patterns, Function} ->
                    Acc@3 = fold_expression(Function, Scope@1, Acc@2, Fun),
                    Scope@3 = gleam@list:fold(
                        Patterns,
                        Scope@1,
                        fun(Scope@2, Use_pattern) ->
                            update_scope_from_patterns(
                                Scope@2,
                                [erlang:element(2, Use_pattern)]
                            )
                        end
                    ),
                    {Scope@3, Acc@3};

                {assignment, _, _, Pattern, _, Value} ->
                    Acc@4 = fold_expression(Value, Scope@1, Acc@2, Fun),
                    Scope@4 = update_scope_from_patterns(Scope@1, [Pattern]),
                    {Scope@4, Acc@4};

                {assert, _, Expression, none} ->
                    {Scope@1, fold_expression(Expression, Scope@1, Acc@2, Fun)};

                {assert, _, Expression@1, {some, Message}} ->
                    Acc@5 = fold_expression(Expression@1, Scope@1, Acc@2, Fun),
                    {Scope@1, fold_expression(Message, Scope@1, Acc@5, Fun)};

                {expression, Expression@2} ->
                    {Scope@1,
                        fold_expression(Expression@2, Scope@1, Acc@2, Fun)}
            end
        end
    ),
    Acc@6.

-file("src/birdie/internal/analyser.gleam", 605).
?DOC(false).
-spec snap_usage(glance:module_()) -> {ok, snap_usage()} | {error, nil}.
snap_usage(Module) ->
    gleam@list:find_map(
        erlang:element(2, Module),
        fun(Import_) ->
            {import, _, Module@1, Alias, _, Unqualified_values} = erlang:element(
                3,
                Import_
            ),
            gleam@bool:guard(
                Module@1 /= <<"birdie"/utf8>>,
                {error, nil},
                fun() ->
                    Unqualified_snap_name = gleam@list:find_map(
                        Unqualified_values,
                        fun(Unqualified_import) -> case Unqualified_import of
                                {unqualified_import, <<"snap"/utf8>>, none} ->
                                    {ok, <<"snap"/utf8>>};

                                {unqualified_import,
                                    <<"snap"/utf8>>,
                                    {some, Name}} ->
                                    {ok, Name};

                                {unqualified_import, _, {some, _}} ->
                                    {error, nil};

                                {unqualified_import, _, none} ->
                                    {error, nil}
                            end end
                    ),
                    case {Alias, Unqualified_snap_name} of
                        {none, {ok, Snap_name}} ->
                            {ok,
                                {qualified_and_unqualified,
                                    <<"birdie"/utf8>>,
                                    Snap_name}};

                        {{some, {named, Birdie_name}}, {ok, Snap_name@1}} ->
                            {ok,
                                {qualified_and_unqualified,
                                    Birdie_name,
                                    Snap_name@1}};

                        {{some, {discarded, _}}, {ok, Snap_name@2}} ->
                            {ok, {only_unqualified, Snap_name@2}};

                        {none, {error, _}} ->
                            {ok, {only_qualified, <<"birdie"/utf8>>}};

                        {{some, {discarded, _}}, {error, _}} ->
                            {error, nil};

                        {{some, {named, Birdie_name@1}}, {error, _}} ->
                            {ok, {only_qualified, Birdie_name@1}}
                    end
                end
            )
        end
    ).

-file("src/birdie/internal/analyser.gleam", 277).
?DOC(false).
-spec analyse_module(module_()) -> {ok, analysed_module()} | {error, nil}.
analyse_module(Module) ->
    gleam@result:'try'(
        begin
            _pipe = glance:module(erlang:element(3, Module)),
            gleam@result:replace_error(_pipe, nil)
        end,
        fun(Parsed_module) ->
            gleam@result:'try'(
                snap_usage(Parsed_module),
                fun(Snap_usage) ->
                    Snapshots@2 = begin
                        gleam@list:fold(
                            erlang:element(6, Parsed_module),
                            [],
                            fun(Snapshots, Function) ->
                                Body = erlang:element(
                                    7,
                                    erlang:element(3, Function)
                                ),
                                Function_name = erlang:element(
                                    3,
                                    erlang:element(3, Function)
                                ),
                                Function_name_start = erlang:element(
                                    2,
                                    erlang:element(
                                        2,
                                        erlang:element(3, Function)
                                    )
                                )
                                + 7,
                                Function_name_span = {span,
                                    Function_name_start,
                                    Function_name_start + erlang:byte_size(
                                        Function_name
                                    )},
                                Scope = {scope, gleam@set:new()},
                                fold_statements(
                                    Body,
                                    Scope,
                                    Snapshots,
                                    fun(Snapshots@1, Scope@1, Expression) ->
                                        Snapshot = snapshot_test(
                                            Snap_usage,
                                            Scope@1,
                                            Function_name,
                                            Function_name_span,
                                            Expression
                                        ),
                                        case Snapshot of
                                            {ok, Snapshot@1} ->
                                                [Snapshot@1 | Snapshots@1];

                                            {error, _} ->
                                                Snapshots@1
                                        end
                                    end
                                )
                            end
                        )
                    end,
                    case Snapshots@2 of
                        [] ->
                            {error, nil};

                        [_ | _] ->
                            {ok,
                                {analysed_module,
                                    erlang:element(2, Module),
                                    erlang:element(3, Module),
                                    Snapshots@2}}
                    end
                end
            )
        end
    ).

-file("src/birdie/internal/analyser.gleam", 240).
?DOC(false).
-spec analyse(analyser(), module_()) -> analyser().
analyse(Analyser, Module) ->
    case analyse_module(Module) of
        {error, _} ->
            Analyser;

        {ok, Module@1} ->
            add_analysed_module(Analyser, Module@1)
    end.

-file("src/birdie/internal/analyser.gleam", 906).
?DOC(false).
-spec error_to_diagnostic(error()) -> birdie@internal@diagnostic:diagnostic().
error_to_diagnostic(Error) ->
    case Error of
        {title_already_in_use, Module, Test_function_name_span, Title_span} ->
            {diagnostic,
                erro,
                <<"duplicate snapshot title"/utf8>>,
                {some,
                    {label,
                        erlang:element(6, erlang:element(2, Module)),
                        erlang:element(3, Module),
                        Title_span,
                        <<"multiple snapshots have this title"/utf8>>,
                        {some,
                            {Test_function_name_span,
                                <<"defined in this function"/utf8>>}}}},
                <<"Snapshot titles should be unique but title is duplicated."/utf8>>,
                {some, <<"change this title so that it is unique"/utf8>>}}
    end.
