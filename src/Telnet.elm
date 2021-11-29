module Telnet exposing (codes),


codes =
    [
            -- // Negotiation Bytes
    (IAC, '\xFF', 255),
    (DONT, "\xFE", 254),
    (DO, "\xFD", 253),
    (WONT, "\xFC", 252),
    (WILL, "\xFB", 251),
    (SB, "\xFA", 250),
    (SE, "\xF0", 240),
    (ESC, "\x1B"),
    (BEL, "\x07"),
    (IS, "\x00", 0),

-- END-(OF-RECORD Marker / GO-AHEAD),
    (EORc, "\xEF", 239),
    (GA, "\xF9", 249),

-- TELNET Options
    (BINARY, "\x00", 0),
    (ECHO, "\x01", 1),
    (SUPGA, "\x03", 3),
    (STATUS, "\x05", 5),
    (SENDLOC, "\x17", 23),
    (TTYPE, "\x18", 24),
    (EOR, "\x19", 25),
    (NAWS, "\x1F", 31),
    (TSPEED, "\x20", 32),
    (RFLOW, "\x21", 33),
    (LINEMODE, "\x22", 34),
    (AUTH, "\x23", 35),
    (NEWENV, "\x27", 39),
    (CHARSET, "\x2A", 42),

    (MSDP, "E", 69),
    (MSSP, "F", 70),
    (COMPRESS, "U", 85),
    (COMPRESSv2, "V", 86),
    (MSP, "Z", 90),
    (MXP, "[", 91),
    (ZMP, "]", 93),
    (CONQUEST, "^", 94),
    (ATCP, "\xC8", 200),
    (GMCP, "\xC9", 201),
    ]
