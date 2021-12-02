module Discworld.Tests exposing (..)

import Discworld
    exposing
        ( mudData
        , parseDiscLine
        )
import Expect
import Test as T


all : T.Test
all =
    T.describe "EVERYTHING" [ parsing ]


parsing : T.Test
parsing =
    T.describe "Parsing"
        [ T.test "pulls string from between parens" <|
            \() ->
                Expect.equal
                    (parseDiscLine "kljdafk[kafdafdaf]adfdf")
                    "kafdafdaf"
        , T.test "splits zmp data from stream" <|
            \() ->
                Expect.equal
                    (mudData "kljdafk[kafdafdaf]adfdf")
                    ( "kljdafk[kafdafdaf]adfdf", "kafdafdaf" )

        -- , T.test "handles data"
        ]