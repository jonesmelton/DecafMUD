module Discparse.Tests exposing (..)

import Discparse exposing (parseDiscLine, zmp)
import Expect
import Test as T


all : T.Test
all =
    T.describe "ANSI" [ parsing, zmp ]


parsing : T.Test
parsing =
    T.describe "Parsing"
        [ T.test "pulls inner value" <|
            \() ->
                Expect.equal
                    (parseDiscLine "jkhdafkjhfjkd[DAFDAFdlkkkIHUIJfklfj92898xvcz9438298fieruui9849389]")
                    "[DAFDAFdlkkkIHUIJfklfj92898xvcz9438298fieruui9849389]"
        ]


zmp =
    T.describe "Zmp"
        [ T.test "finds a character" <|
            \() ->
                Expect.equal 1 1
        ]
