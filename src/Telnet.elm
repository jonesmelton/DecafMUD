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

        252 ->
            "WONT"

        251 ->
            "WILL"

        250 ->
            "SB"

        240 ->
            "SE"

        0 ->
            "IS"

        239 ->
            "EORc"

        249 ->
            "GA"

        200 ->
            "ATCP"

        201 ->
            "GMCP"

        1 ->
            "ECHO"

        3 ->
            "SUPGA"

        5 ->
            "STATUS"

        23 ->
            "SENDLOC"

        24 ->
            "TTYPE"

        25 ->
            "EOR"

        31 ->
            "NAWS"

        32 ->
            "TSPEED"

        33 ->
            "RFLOW"

        34 ->
            "LINEMODE"

        35 ->
            "AUTH"

        39 ->
            "NEWENV"

        42 ->
            "CHARSET"

        69 ->
            "MSDP"

        70 ->
            "MSSP"

        85 ->
            "COMPRESS"

        86 ->
            "COMPRESSv2"

        90 ->
            "MSP"

        91 ->
            "MXP"

        93 ->
            "ZMP"

        94 ->
            "CONQUEST"

        any ->
            "[" ++ String.fromInt any ++ "]"
