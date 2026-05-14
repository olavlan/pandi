-module(pandi@pandoc).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/pandi/pandoc.gleam").
-export_type([attributes/0, list_number_style/0, list_number_delimiter/0, list_attributes/0, block/0, inline/0, target/0, document/0]).

-type attributes() :: {attributes,
        binary(),
        list(binary()),
        list({binary(), binary()})}.

-type list_number_style() :: decimal |
    lower_alpha |
    upper_alpha |
    lower_roman |
    upper_roman.

-type list_number_delimiter() :: period | one_paren | two_parens.

-type list_attributes() :: {list_attributes,
        integer(),
        list_number_style(),
        list_number_delimiter()}.

-type block() :: {header, integer(), attributes(), list(inline())} |
    {para, list(inline())} |
    {plain, list(inline())} |
    {code_block, attributes(), binary()} |
    {'div', attributes(), list(block())} |
    {bullet_list, list(list(block()))} |
    {ordered_list, list_attributes(), list(list(block()))} |
    {block_quote, list(block())}.

-type inline() :: {str, binary()} |
    space |
    line_break |
    soft_break |
    {emph, list(inline())} |
    {strong, list(inline())} |
    {strikeout, list(inline())} |
    {code, attributes(), binary()} |
    {span, attributes(), list(inline())} |
    {link, attributes(), list(inline()), target()}.

-type target() :: {target, binary(), binary()}.

-type document() :: {document, list(block()), list({binary(), binary()})}.


