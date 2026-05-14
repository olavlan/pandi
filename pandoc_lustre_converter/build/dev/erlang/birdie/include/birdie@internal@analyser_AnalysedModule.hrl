-record(analysed_module, {
    path :: gleam@uri:uri(),
    source :: binary(),
    snapshots :: list(birdie@internal@analyser:snapshot_test())
}).
