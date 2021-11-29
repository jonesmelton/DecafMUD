module Discparse exposing (parseDiscLine)

import Parser exposing (Parser)


parseDiscLine : String -> String
parseDiscLine line =
    line
