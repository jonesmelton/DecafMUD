module Discparse exposing (parseDiscLine)

import Parser exposing (..)


parseDiscLine : String -> String
parseDiscLine line =
    let
        res =
            run simpleP line
    in
    case res of
        Ok val ->
            val

        -- List.map String.fromInt [ val.res, val.reso ]
        --     |> String.join ""
        Err err ->
            Debug.toString err


simpleP : Parser String
simpleP =
    succeed (String.append "")
        |. chompIf Char.isAlpha
        |. chompWhile Char.isAlpha
        |. symbol "["
        |= getChompedString (chompUntil "]")


deadEndsToString : List DeadEnd -> String
deadEndsToString deadends =
    let
        pToString p =
            case p of
                Expecting expecting ->
                    expecting

                ExpectingSymbol sym ->
                    sym

                ExpectingInt ->
                    "expecting int"

                _ ->
                    "something else"
    in
    List.map .problem deadends
        |> List.map pToString
        |> String.join ""
