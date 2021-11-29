module Discparse exposing (parseDiscLine, zmp)

import Parser as P exposing ((|.), (|=), Parser)



-- parseDiscLine : String -> String


deadEndsToString : List P.DeadEnd -> String
deadEndsToString deadends =
    let
        pToString p =
            case p of
                P.Expecting expecting ->
                    expecting

                P.ExpectingSymbol sym ->
                    sym

                P.Problem str ->
                    str

                _ ->
                    "something else"
    in
    List.map .problem deadends
        |> List.map pToString
        |> String.join ""


parseDiscLine line =
    let
        res =
            P.run zmp line
    in
    case res of
        Ok val ->
            val

        Err err ->
            deadEndsToString err


zmp =
    P.getChompedString <|
        P.succeed identity
            |. P.symbol "["
            |= P.chompUntil "]"
