-module(in).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/in.gleam").
-export([read_chars/1, read_line/0]).
-export_type([encoding/0, error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type encoding() :: latin1 | unicode | utf8 | utf16 | utf32.

-type error() :: eof |
    badarg |
    terminated |
    {no_translation, encoding(), encoding()} |
    eacces |
    eagain |
    ebadf |
    ebadmsg |
    ebusy |
    edeadlk |
    edeadlock |
    edquot |
    eexist |
    efault |
    efbig |
    eftype |
    eintr |
    einval |
    eio |
    eisdir |
    eloop |
    emfile |
    emlink |
    emultihop |
    enametoolong |
    enfile |
    enobufs |
    enodev |
    enolck |
    enolink |
    enoent |
    enomem |
    enospc |
    enosr |
    enostr |
    enosys |
    enotblk |
    enotdir |
    enotsup |
    enxio |
    eopnotsupp |
    eoverflow |
    eperm |
    epipe |
    erange |
    erofs |
    espipe |
    esrch |
    estale |
    etxtbsy |
    exdev.

-file("src/in.gleam", 82).
?DOC(
    " Converts an internal `IoResult(String, Error)`\n"
    " returned by the FFI into a `Result(String, Error)`.\n"
).
-spec ioresult_to_result(in@internal:io_result(binary(), error())) -> {ok,
        binary()} |
    {error, error()}.
ioresult_to_result(Ffi) ->
    case Ffi of
        {ok, S} ->
            {ok, S};

        eof ->
            {error, eof};

        {error, E} ->
            {error, E}
    end.

-file("src/in.gleam", 95).
?DOC(
    " Reads up to `number` characters from the standard input.\n"
    "\n"
    " If the requested number of characters exceeds the available input,\n"
    " returns everything until the end of input.\n"
).
-spec read_chars(integer()) -> {ok, binary()} | {error, error()}.
read_chars(Number) ->
    _pipe = file:read(standard_io, Number),
    ioresult_to_result(_pipe).

-file("src/in.gleam", 102).
?DOC(" Reads a line from the standard input.\n").
-spec read_line() -> {ok, binary()} | {error, error()}.
read_line() ->
    _pipe = file:read_line(standard_io),
    ioresult_to_result(_pipe).
