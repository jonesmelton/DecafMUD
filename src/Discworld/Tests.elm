module Discworld.Tests exposing (..)

import Discworld exposing (removeIntroGmcp)
import Discworld.Parse exposing (applyTelnetAnnotations)
import Expect
import Test as T


all : T.Test
all =
    T.describe "EVERYTHING" [ gmcp, telnetAnnotate ]


gmcp : T.Test
gmcp =
    T.describe "Gmcp"
        [ T.test "remove gmcp data from line containing it" <|
            \() ->
                Expect.equal
                    (removeIntroGmcp "Your choice: ÿúÿðÿúFNAMEDiscworldPLAYERS67UPTIME1636484176WORLDS1FAMILYLPMudIP82.68.167.69ROLEPLAYINGAcceptedCREATED1991PAY TO PLAY0PAY FOR PERKS0PORT234242WORLD ORIGINALITYAll OriginalTRAINING SYSTEMBothLOCATIONUnited KingdomSTATUSLiveCODEBASEDiscworld lib (current)MXP1MULTIPLAYINGNoneWEBSITEhttp://discworld.starturtle.netINTERMUDIMC2I3PLAYERKILLINGRestrictedHOSTNAMEdiscworld.starturtle.netGENREFantasyGAMEPLAYRoleplayingPlayer versus PlayerHack and SlashAdventureLANGUAGEEnglishVT1001MCCP1ANSI1SUBGENREDiscworldÿð")
                    "Your choice: "
        , T.test "doesn't change lines without gmcp data" <|
            \() ->
                Expect.equal
                    (removeIntroGmcp "A large, floppy, black hat recedes into the distance, somehow looking satisfied at what it has left behind.")
                    "A large, floppy, black hat recedes into the distance, somehow looking satisfied at what it has left behind."
        ]

telnetAnnotate : T.Test
telnetAnnotate =
    T.describe "Parsing"
        [ T.test "annotate command strings with numbers" <|
            \() ->
                Expect.equal
                    (applyTelnetAnnotations "kfkÿkaafÿadfdf")
                    "kfk[IAC]kaaf[IAC]adfdf"
        ]
