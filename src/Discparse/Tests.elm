module Discparse.Tests exposing (..)

import Discparse exposing (parseDiscLine)
import Expect
import Test as T


all : T.Test
all =
    T.describe "EVERYTHING" [ parsing ]


parsing : T.Test
parsing =
    T.describe "Parsing"
        [ T.test "basic basic" <|
            \() ->
                Expect.equal
                    (parseDiscLine "kljdafk[kafdafdaf]adfdf")
                    "kafdafdaf"
        ]
