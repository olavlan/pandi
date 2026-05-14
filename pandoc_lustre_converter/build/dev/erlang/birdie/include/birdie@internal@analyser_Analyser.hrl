-record(analyser, {
    modules :: gleam@dict:dict(gleam@uri:uri(), birdie@internal@analyser:analysed_module()),
    literal_titles :: gleam@dict:dict(binary(), gleam@dict:dict(gleam@uri:uri(), list(birdie@internal@analyser:snapshot_test())))
}).
