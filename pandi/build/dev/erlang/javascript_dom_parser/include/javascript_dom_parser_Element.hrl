-record(element, {
    tag :: binary(),
    attributes :: list({binary(), binary()}),
    children :: list(javascript_dom_parser:html_node())
}).
