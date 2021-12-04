module Discworld exposing (filterZmp, mudData, parseDiscLine)

import Ansi
import Html as H
import Parser exposing (..)


filterZmp : String -> String
filterZmp line =
    let
        res =
            run zmp3 line
    in
    case res of
        Ok val ->
            val

        Err err ->
            deadEndsToString err


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
mudData line =
    ( parseDiscLine line, "" )


n_mudData ln =
    let
        zmpData =
            parseDiscLine ln

        cleanLine =
            String.replace zmpData ""
    in
    ( cleanLine ln, zmpData )


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
            if isAsciiChar char then
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


zmp3 : Parser String
zmp3 =
    succeed (String.append "")
        |. ascii
        |. chompIf (code 255)
        |. chompIf (code 250)
        |= getChompedString (chompUntilEndOr "\\")



-- |. chompIf (code 255)
-- |. anything
-- |. end


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


isAsciiChar : Char -> Bool
isAsciiChar char =
    let
        charCode =
            Char.toCode char
    in
    charCode < 128


isNotAsciiChar : Char -> Bool
isNotAsciiChar =
    not << isAsciiChar



-- code : Int -> (Char -> Parser Char)


code : Int -> (Char -> Bool)
code cd =
    \c -> Char.toCode c == cd


ascii : Parser String
ascii =
    succeed (String.append "")
        |= getChompedString (chompWhile isAsciiChar)



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
