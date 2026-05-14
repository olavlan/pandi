-module(birdie@internal@diagnostic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/birdie/internal/diagnostic.gleam").
-export([to_string/1]).
-export_type([diagnostic/0, level/0, label/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type diagnostic() :: {diagnostic,
        level(),
        binary(),
        gleam@option:option(label()),
        binary(),
        gleam@option:option(binary())}.

-type level() :: warn | erro.

-type label() :: {label,
        binary(),
        binary(),
        glance:span(),
        binary(),
        gleam@option:option({glance:span(), binary()})}.

-file("src/birdie/internal/diagnostic.gleam", 227).
?DOC(false).
-spec colour_string_between_bytes(
    binary(),
    integer(),
    integer(),
    fun((binary()) -> binary())
) -> binary().
colour_string_between_bytes(String, Start, End, Colour) ->
    Result = case <<String/binary>> of
        <<Prefix:Start/binary, To_colour:(End - Start)/binary, Suffix/binary>> ->
            gleam@result:'try'(
                gleam@bit_array:to_string(Prefix),
                fun(Prefix@1) ->
                    gleam@result:'try'(
                        gleam@bit_array:to_string(To_colour),
                        fun(To_colour@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:to_string(Suffix),
                                fun(Suffix@1) ->
                                    {ok,
                                        <<<<Prefix@1/binary,
                                                (Colour(To_colour@1))/binary>>/binary,
                                            Suffix@1/binary>>}
                                end
                            )
                        end
                    )
                end
            );

        _ ->
            {error, nil}
    end,
    gleam@result:unwrap(Result, String).

-file("src/birdie/internal/diagnostic.gleam", 260).
?DOC(false).
-spec get_line_loop(binary(), integer(), integer(), integer()) -> {binary(),
    integer(),
    integer()}.
get_line_loop(String, Line_number, Trimmed_bytes, Byte) ->
    case gleam@string:split_once(String, <<"\n"/utf8>>) of
        {error, _} ->
            {String, Line_number, Trimmed_bytes};

        {ok, {Line, Rest}} ->
            case (Trimmed_bytes + erlang:byte_size(Line)) + 1 of
                Trimmed when Trimmed > Byte ->
                    {Line, Line_number, Trimmed_bytes};

                Trimmed@1 ->
                    get_line_loop(Rest, Line_number + 1, Trimmed@1, Byte)
            end
    end.

-file("src/birdie/internal/diagnostic.gleam", 256).
?DOC(false).
-spec get_line(binary(), integer()) -> {binary(), integer(), integer()}.
get_line(String, Byte) ->
    get_line_loop(String, 1, 0, Byte).

-file("src/birdie/internal/diagnostic.gleam", 76).
?DOC(false).
-spec label_to_string(level(), label()) -> binary().
label_to_string(Level, Label) ->
    {label, File_name, Source, Position, Content, Secondary_label} = Label,
    Colour = case Level of
        warn ->
            fun gleam_community@ansi:yellow/1;

        erro ->
            fun gleam_community@ansi:red/1
    end,
    {Start_line, Start_line_number, Trimmed_to_start} = get_line(
        Source,
        erlang:element(2, Position)
    ),
    {End_line, End_line_number, Trimmed_to_end} = get_line(
        Source,
        erlang:element(3, Position)
    ),
    Is_single_line = Start_line_number =:= End_line_number,
    Required_digits = begin
        _pipe = erlang:integer_to_binary(Start_line_number),
        _pipe@1 = string:length(_pipe),
        gleam@int:max(
            _pipe@1,
            begin
                _pipe@2 = erlang:integer_to_binary(End_line_number),
                string:length(_pipe@2)
            end
        )
    end,
    File_name@1 = <<<<(gleam@string:repeat(<<" "/utf8>>, Required_digits))/binary,
            (gleam_community@ansi:dim(<<" ╭─ "/utf8>>))/binary>>/binary,
        File_name/binary>>,
    Empty_line = <<(gleam@string:repeat(<<" "/utf8>>, Required_digits))/binary,
        (gleam_community@ansi:dim(<<" │"/utf8>>))/binary>>,
    Highlighted_code = case Is_single_line of
        true ->
            Start_line@1 = colour_string_between_bytes(
                Start_line,
                erlang:element(2, Position) - Trimmed_to_start,
                erlang:element(3, Position) - Trimmed_to_start,
                Colour
            ),
            <<(gleam_community@ansi:dim(
                    <<(erlang:integer_to_binary(Start_line_number))/binary,
                        " │ "/utf8>>
                ))/binary,
                Start_line@1/binary>>;

        false ->
            Start_line@2 = colour_string_between_bytes(
                Start_line,
                erlang:element(2, Position) - Trimmed_to_start,
                erlang:byte_size(Start_line),
                Colour
            ),
            End_line@1 = colour_string_between_bytes(
                End_line,
                0,
                erlang:element(3, Position) - Trimmed_to_end,
                Colour
            ),
            Start_line@3 = <<(gleam_community@ansi:dim(
                    <<(gleam@string:pad_start(
                            erlang:integer_to_binary(Start_line_number),
                            Required_digits,
                            <<" "/utf8>>
                        ))/binary,
                        " │ "/utf8>>
                ))/binary,
                Start_line@2/binary>>,
            End_line@2 = <<(gleam_community@ansi:dim(
                    <<(gleam@string:pad_start(
                            erlang:integer_to_binary(End_line_number),
                            Required_digits,
                            <<" "/utf8>>
                        ))/binary,
                        " │ "/utf8>>
                ))/binary,
                End_line@1/binary>>,
            case End_line_number - Start_line_number of
                0 ->
                    <<<<Start_line@3/binary, "\n"/utf8>>/binary,
                        End_line@2/binary>>;

                1 ->
                    <<<<Start_line@3/binary, "\n"/utf8>>/binary,
                        End_line@2/binary>>;

                _ ->
                    Dashed_line = <<(gleam@string:repeat(
                            <<" "/utf8>>,
                            Required_digits
                        ))/binary,
                        (gleam_community@ansi:dim(<<" ╎"/utf8>>))/binary>>,
                    <<<<<<<<Start_line@3/binary, "\n"/utf8>>/binary,
                                Dashed_line/binary>>/binary,
                            "\n"/utf8>>/binary,
                        End_line@2/binary>>
            end
    end,
    Tooltip = case Is_single_line of
        true ->
            <<<<<<<<Empty_line/binary, " "/utf8>>/binary,
                        (gleam@string:repeat(
                            <<" "/utf8>>,
                            erlang:element(2, Position) - Trimmed_to_start
                        ))/binary>>/binary,
                    (gleam@string:repeat(
                        Colour(<<"^"/utf8>>),
                        erlang:element(3, Position) - erlang:element(
                            2,
                            Position
                        )
                    ))/binary>>/binary,
                (case gleam@string:trim(Content) of
                    <<""/utf8>> ->
                        <<""/utf8>>;

                    Content@1 ->
                        <<" "/utf8, (Colour(Content@1))/binary>>
                end)/binary>>;

        false ->
            <<<<<<Empty_line/binary, " "/utf8>>/binary,
                    (gleam@string:repeat(
                        Colour(<<"^"/utf8>>),
                        erlang:byte_size(Start_line)
                    ))/binary>>/binary,
                (case gleam@string:trim(Content) of
                    <<""/utf8>> ->
                        <<""/utf8>>;

                    Content@2 ->
                        <<" "/utf8, (Colour(Content@2))/binary>>
                end)/binary>>
    end,
    Primary_label = <<<<Highlighted_code/binary, "\n"/utf8>>/binary,
        Tooltip/binary>>,
    Labels = case Secondary_label of
        none ->
            Primary_label;

        {some, {Span, Content@3}} ->
            {Secondary_line, Secondary_line_number, Dropped_bytes} = get_line(
                Source,
                erlang:element(2, Span)
            ),
            Secondary_line@1 = colour_string_between_bytes(
                Secondary_line,
                erlang:element(2, Span) - Dropped_bytes,
                erlang:element(3, Span) - Dropped_bytes,
                fun gleam_community@ansi:dim/1
            ),
            Secondary_tooltip = <<<<<<<<Empty_line/binary, " "/utf8>>/binary,
                        (gleam@string:repeat(
                            <<" "/utf8>>,
                            erlang:element(2, Span) - Dropped_bytes
                        ))/binary>>/binary,
                    (gleam@string:repeat(
                        gleam_community@ansi:dim(<<"~"/utf8>>),
                        erlang:element(3, Span) - erlang:element(2, Span)
                    ))/binary>>/binary,
                (case gleam@string:trim(Content@3) of
                    <<""/utf8>> ->
                        <<""/utf8>>;

                    Content@4 ->
                        <<" "/utf8,
                            (gleam_community@ansi:dim(Content@4))/binary>>
                end)/binary>>,
            Secondary_label@1 = <<<<<<(gleam_community@ansi:dim(
                            <<(gleam@string:pad_start(
                                    erlang:integer_to_binary(
                                        Secondary_line_number
                                    ),
                                    Required_digits,
                                    <<" "/utf8>>
                                ))/binary,
                                " │ "/utf8>>
                        ))/binary,
                        Secondary_line@1/binary>>/binary,
                    "\n"/utf8>>/binary,
                Secondary_tooltip/binary>>,
            Dashed_line@1 = <<(gleam@string:repeat(
                    <<" "/utf8>>,
                    Required_digits
                ))/binary,
                (gleam_community@ansi:dim(<<" ╎"/utf8>>))/binary>>,
            case Secondary_line_number - Start_line_number of
                0 ->
                    Primary_label;

                1 ->
                    <<<<Primary_label/binary, "\n"/utf8>>/binary,
                        Secondary_label@1/binary>>;

                N when N =:= -1 ->
                    <<<<Secondary_label@1/binary, "\n"/utf8>>/binary,
                        Primary_label/binary>>;

                N@1 when N@1 < 0 ->
                    <<<<<<<<Secondary_label@1/binary, "\n"/utf8>>/binary,
                                Dashed_line@1/binary>>/binary,
                            "\n"/utf8>>/binary,
                        Primary_label/binary>>;

                _ ->
                    <<<<<<<<Primary_label/binary, "\n"/utf8>>/binary,
                                Dashed_line@1/binary>>/binary,
                            "\n"/utf8>>/binary,
                        Secondary_label@1/binary>>
            end
    end,
    <<<<<<<<<<<<File_name@1/binary, "\n"/utf8>>/binary, Empty_line/binary>>/binary,
                    "\n"/utf8>>/binary,
                Labels/binary>>/binary,
            "\n"/utf8>>/binary,
        Empty_line/binary>>.

-file("src/birdie/internal/diagnostic.gleam", 45).
?DOC(false).
-spec to_string(diagnostic()) -> binary().
to_string(Diagnostic) ->
    {diagnostic, Level, Title, Label, Text, Hint} = Diagnostic,
    Text@1 = gleam@string:trim(Text),
    Heading = case Level of
        warn ->
            gleam_community@ansi:yellow(<<"warning"/utf8>>);

        erro ->
            gleam_community@ansi:red(<<"error"/utf8>>)
    end,
    Error = gleam_community@ansi:bold(
        <<<<Heading/binary, ": "/utf8>>/binary, Title/binary>>
    ),
    Error@1 = case Label of
        none ->
            Error;

        {some, Label@1} ->
            <<<<Error/binary, "\n"/utf8>>/binary,
                (label_to_string(Level, Label@1))/binary>>
    end,
    Error@2 = case gleam@string:trim(Text@1) of
        <<""/utf8>> ->
            Error@1;

        Text@2 ->
            <<<<Error@1/binary, "\n"/utf8>>/binary, Text@2/binary>>
    end,
    Error@3 = case gleam@option:map(Hint, fun gleam@string:trim/1) of
        {some, <<""/utf8>>} ->
            Error@2;

        none ->
            Error@2;

        {some, Hint@1} ->
            <<<<Error@2/binary, "\nHint: "/utf8>>/binary, Hint@1/binary>>
    end,
    Error@3.
