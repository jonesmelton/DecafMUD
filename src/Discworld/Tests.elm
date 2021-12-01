module Discworld.Tests exposing (..)

import Discworld exposing (parseDiscLine)
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
        , T.test "changes to input when there is no match" <|
            \() ->
                Expect.equal
                    (parseDiscLine "uuiuyuiklmknmnnmnr")
                    "uuiuyuiklmknmnnmnr"
        ]
