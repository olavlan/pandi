-record(diagnostic, {
    level :: birdie@internal@diagnostic:level(),
    title :: binary(),
    label :: gleam@option:option(birdie@internal@diagnostic:label()),
    text :: binary(),
    hint :: gleam@option:option(binary())
}).
