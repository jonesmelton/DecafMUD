module Discparse.Tests exposing (..)

import Discparse exposing (parseDiscLine)
import Expect
import Test as T


all : T.Test
all =
    T.describe "ANSI" [ parsing ]


parsing : T.Test
parsing =
    T.describe "Parsing"
        [ T.test "doesn't transform stream" <|
            \() ->
                Expect.equal
                    (parseDiscLine "toot")
                    "toot"
        ]
