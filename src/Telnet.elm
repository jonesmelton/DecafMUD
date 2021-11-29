module Telnet exposing (Code, codeFromPoint, toString)

import List exposing (head)



-- http://www.faqs.org/rfcs/rfc854.html


codeFromPoint : Int -> Code
codeFromPoint charCode =
    let
        mbCode =
            List.filter (\( _, _, code ) -> code == charCode) codes
                |> head
    in
    case mbCode of
        Nothing ->
            ( "", "", 0 )

        Just c ->
            c



-- codeFromChar : Char -> Code
-- codeFromChar char =
--     char


toString : Code -> String
toString ( com, symbol, code ) =
    """
    ( command, symbol, code )
    
""" ++ "( " ++ com ++ " , " ++ symbol ++ " , " ++ String.fromInt code ++ " )"


type alias Code =
    ( String, String, Int )


codes : List Code
codes =
    [ -- // Negotiation Bytes
      ( "IAC", "ÿ", 255 )
    , ( "DONT", "þ", 254 )
    , ( "DO", "ý", 253 )
    , ( "WONT", "ü", 252 )
    , ( "WILL", "û", 251 )
    , -- SB: subnegotiaton begin
      -- SE: subnegotiation end
      ( "SB", "ú", 250 )
    , ( "SE", "ð", 240 )
    , ( "ESC", "\u{001B}", 27 )
    , ( "BEL", "\u{0007}", 7 )
    , ( "IS", "\u{0000}", 0 )
    , -- END-(OF-RECORD Marker / GO-AHEAD)
      ( "EORc", "ï", 239 )
    , ( "GA", "ù", 249 )
    , -- TELNET Options
      ( "BINARY", "\u{0000}", 0 )
    , ( "ECHO", "\u{0001}", 1 )
    , ( "SUPGA", "\u{0003}", 3 )
    , ( "STATUS", "\u{0005}", 5 )
    , ( "SENDLOC", "\u{0017}", 23 )
    , ( "TTYPE", "\u{0018}", 24 )
    , ( "EOR", "\u{0019}", 25 )
    , ( "NAWS", "\u{001F}", 31 )
    , ( "TSPEED", " ", 32 )
    , ( "RFLOW", "!", 33 )
    , ( "LINEMODE", "\"", 34 )
    , ( "AUTH", "#", 35 )
    , ( "CHARSET", "*", 42 )
    , ( "MSDP", "E", 69 )
    , ( "MSSP", "F", 70 )
    , ( "COMPRESS", "U", 85 )
    , ( "COMPRESSv2", "V", 86 )
    , ( "MSP", "Z", 90 )
    , ( "MXP", "[", 91 )
    , ( "ZMP", "]", 93 )
    , ( "CONQUEST", "^", 94 )
    , ( "ATCP", "È", 200 )
    , ( "GMCP", "É", 201 )
    ]
