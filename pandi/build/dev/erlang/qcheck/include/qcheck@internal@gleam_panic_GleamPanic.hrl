-record(gleam_panic, {
    message :: binary(),
    file :: binary(),
    module :: binary(),
    function :: binary(),
    line :: integer(),
    kind :: qcheck@internal@gleam_panic:panic_kind()
}).
