module Discworld exposing (..)

import Regex exposing (Regex)


removeIntroGmcp : String -> String
removeIntroGmcp line =
    -- Regex.replace gmcpIntro (\_ -> "") line
    line


gmcpIntro : Regex
gmcpIntro =
    Maybe.withDefault Regex.never <|
        Regex.fromString "[IAC].*"
