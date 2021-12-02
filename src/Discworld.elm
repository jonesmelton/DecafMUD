module Discworld exposing (mudData, parseDiscLine)

import Ansi exposing (parse)
import Html as H
import Parser exposing (..)


parseDiscLine : String -> String
parseDiscLine line =
    let
        res =
            run anything line
    in
    case res of
        Ok val ->
            val

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



-- takes a string but turns non-ascii chars into their char codes
-- necessary bc the server uses ascii within utf-8. non-ascii code points
-- are used for negotiation and commands
-- "ÿýÿýÿý[ÿûFÿû]ÿý'ÿûÉ"


stringToCodes : String -> String
stringToCodes string =
    let
        legalChar : Char -> String
        legalChar char =
            if Char.toCode char <= 127 then
                String.fromChar char

            else
                String.fromChar char
                    ++ ": "
                    ++ (Char.toCode char
                            |> String.fromInt
                            |> String.pad 5 ' '
                       )
    in
    string
        |> String.toList
        |> List.map legalChar
        |> String.join ""


zmp2 : Parser String
zmp2 =
    succeed (String.append "")
        |. chompIf Char.isAlphaNum
        |. chompWhile Char.isAlphaNum
        |. token "ÿú"
        |. chompIf Char.isAlphaNum
        |= getChompedString (chompUntilEndOr "ÿð")


anything : Parser String
anything =
    succeed (String.append "")
        |= (getChompedString <| chompWhile (\c -> True))
        |> andThen (\chr -> succeed (stringToCodes chr))


zmp : Parser String
zmp =
    succeed (String.append "")
        |. chompWhile (\c -> Char.isAlphaNum c)
        |. chompIf (\c -> c == 'ÿ')
        |= getChompedString (chompUntil "ÿ")



-- unicode : Parser Char
-- unicode =
--   getChompedString (chompWhile Char.isHexDigit)
--     |> andThen codeToChar


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
