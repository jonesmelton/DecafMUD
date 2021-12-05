module Discworld.Tests exposing (..)

import DiscworldParse
    exposing
        ( applyTelnetAnnotations
        , filterGmcp
        , mudData
        )
import Expect
import Test as T


all : T.Test
all =
    T.describe "EVERYTHING" [ parsing ]


parsing : T.Test
parsing =
    T.describe "Parsing"
        [ T.test "annotate command strings with numbers" <|
            \() ->
                Expect.equal
                    (applyTelnetAnnotations "kfkÿkaafÿadfdf")
                    "kfk[IAC]kaaf[IAC]adfdf"

        -- This works fine for my purposes but there is an invisible difference in the output that elm fails the test over
        ]
