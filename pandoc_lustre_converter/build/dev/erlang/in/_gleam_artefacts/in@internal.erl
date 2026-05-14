-module(in@internal).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/in/internal.gleam").
-export([ffi_read/2, ffi_read_line/1]).
-export_type([io_device/0, io_result/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type io_device() :: standard_io.

-type io_result(QIR, QIS) :: {ok, QIR} | eof | {error, QIS}.

-file("src/in/internal.gleam", 12).
?DOC(false).
-spec ffi_read(io_device(), integer()) -> io_result(any(), any()).
ffi_read(Device, Number) ->
    file:read(Device, Number).

-file("src/in/internal.gleam", 15).
?DOC(false).
-spec ffi_read_line(io_device()) -> io_result(any(), any()).
ffi_read_line(Device) ->
    file:read_line(Device).
