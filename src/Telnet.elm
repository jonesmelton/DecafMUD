module Telnet exposing (toString)


toString : Int -> String
toString codepoint =
    case codepoint of
        255 ->
            "IAC"

        254 ->
            "DONT"

        253 ->
            "DO"

        _ ->
            ""
