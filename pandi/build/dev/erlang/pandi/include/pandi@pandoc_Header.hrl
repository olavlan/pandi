-record(header, {
    level :: integer(),
    attributes :: pandi@pandoc:attributes(),
    content :: list(pandi@pandoc:inline())
}).
