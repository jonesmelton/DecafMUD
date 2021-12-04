module Discworld.Tests exposing (..)

import Discworld
    exposing
        ( mudData
        , parseDiscLine
        , filterZmp
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
                    (parseDiscLine "kfkÿkaafÿadfdf")
                    "kfkÿ:  255 kaafÿ:  255 adfdf"

        , T.test "handles real one" <|
            \() -> Expect.equal
                (filterZmp "Your choice: ÿúÿðÿúFNAMEDiscworldPLAYERS64UPTIME1636484176WORLDS1FAMILYLPMudIP82.68.167.69ROLEPLAYINGAcceptedCREATED1991PAY TO PLAY0PAY FOR PERKS0PORT234242WORLD ORIGINALITYAll OriginalTRAINING SYSTEMBothLOCATIONUnited KingdomSTATUSLiveCODEBASEDiscworld lib (current)MXP1MULTIPLAYINGNoneWEBSITEhttp://discworld.starturtle.netINTERMUDIMC2I3PLAYERKILLINGRestrictedHOSTNAMEdiscworld.starturtle.netGENREFantasyGAMEPLAYRoleplayingPlayer versus PlayerHack and SlashAdventureLANGUAGEEnglishVT1001MCCP1ANSI1SUBGENREDiscworldÿð")
                "Your choice: "
        ]
