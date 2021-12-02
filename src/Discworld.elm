module Discworld exposing (mudData, parseDiscLine)

import Ansi exposing (parse)
import Html as H
import Parser exposing (..)


parseDiscLine : String -> String
parseDiscLine line =
    let
        res =
            run zmp line
    in
    case res of
        Ok val ->
            val

        -- List.map String.fromInt [ val.res, val.reso ]
        --     |> String.join ""
        Err err ->
            deadEndsToString err


mudData : String -> ( String, String )
mudData ln =
    ( ln, parseDiscLine ln )


deadEndsToHtml : List DeadEnd -> H.Html x
deadEndsToHtml deadends =
    let
        deadendToH : DeadEnd -> H.Html x
        deadendToH deadend =
            H.div []
                [ H.span [] [ H.text <| deadEndToString deadend ] ]
    in
    H.div []
        (List.map
            deadendToH
            deadends
        )


zmp : Parser String
zmp =
    succeed (String.append "")
        |. chompWhile (\c -> Char.isAlphaNum c)
        |. chompIf (\c -> c == 'ÿ')
        |= getChompedString (chompUntil "ÿ")


deadEndToString : DeadEnd -> String
deadEndToString deadEnd =
    let
        position : String
        position =
            "row:" ++ String.fromInt deadEnd.row ++ " col:" ++ String.fromInt deadEnd.col ++ "\n"
    in
    case deadEnd.problem of
        Expecting str ->
            "Expecting " ++ str ++ "at " ++ position

        ExpectingInt ->
            "ExpectingInt at " ++ position

        ExpectingHex ->
            "ExpectingHex at " ++ position

        ExpectingOctal ->
            "ExpectingOctal at " ++ position

        ExpectingBinary ->
            "ExpectingBinary at " ++ position

        ExpectingFloat ->
            "ExpectingFloat at " ++ position

        ExpectingNumber ->
            "ExpectingNumber at " ++ position

        ExpectingVariable ->
            "ExpectingVariable at " ++ position

        ExpectingSymbol str ->
            "ExpectingSymbol " ++ str ++ " at " ++ position

        ExpectingKeyword str ->
            "ExpectingKeyword " ++ str ++ "at " ++ position

        ExpectingEnd ->
            "ExpectingEnd at " ++ position

        UnexpectedChar ->
            "UnexpectedChar at " ++ position

        Problem str ->
            "ProblemString " ++ str ++ " at " ++ position

        BadRepeat ->
            "BadRepeat at " ++ position


deadEndsToString : List DeadEnd -> String
deadEndsToString deadends =
    List.map deadEndToString deadends
        |> String.join " "
