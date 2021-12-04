module Discworld exposing (filterGmcp, mudData, parseDiscLine)

import Ansi
import Html as H
import Parser exposing (..)


filterGmcp : String -> String
filterGmcp line =
    let
        res =
            run gmcp line
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


gmcp : Parser String
gmcp =
    -- ÿúÿðÿú
    -- IAC 201 240
    -- 255 201 240                                       255 240 ???
    -- IAC SB GMCP '<package.subpackage.command>' <data> IAC SE format
    succeed (String.append "")
        |. ascii
        |. chompIf (code 255)
        |. anythingButIAC
        |. chompIf (code 255)
        |. anythingButIAC
        |. chompIf (code 255)
        |. chompIf (code 250)
        |= anythingButIAC
        |. chompIf (code 255)
        |. getChompedString (chompUntilEndOr "\\")


anythingButIAC : Parser String
anythingButIAC =
    succeed (String.append "")
        |= (getChompedString <| chompWhile (\c -> Char.toCode c /= 255))


anything : Parser String
anything =
    succeed (String.append "")
        |= (getChompedString <| chompWhile (\_ -> True))
        |> andThen (\chr -> succeed (stringToCodes chr))


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
