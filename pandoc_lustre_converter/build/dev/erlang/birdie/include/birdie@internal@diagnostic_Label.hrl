-record(label, {
    file_name :: binary(),
    source :: binary(),
    position :: glance:span(),
    content :: binary(),
    secondary_label :: gleam@option:option({glance:span(), binary()})
}).
