-record(assert, {
    start :: integer(),
    'end' :: integer(),
    expression_start :: integer(),
    kind :: qcheck@internal@gleam_panic:assert_kind()
}).
