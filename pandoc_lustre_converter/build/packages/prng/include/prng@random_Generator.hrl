-record(generator, {
    step :: fun((prng@random:seed()) -> {any(), prng@random:seed()})
}).
