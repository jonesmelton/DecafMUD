port module Main exposing (..)

import Ansi exposing (Action(..), parse)
import Ansi.Log as AnsiL
import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Scroll exposing (scrollY)
import Task



-- ÿ = IAC
-- ý = DO
-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- PORTS


port sendToMud : String -> Cmd msg


port sendToElm : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { draft : String
    , inputHistory : List String
    , mudlines : List Ansi.Action
    , ansiModel : AnsiL.Model
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { draft = ""
      , inputHistory = []
      , mudlines = []
      , ansiModel = AnsiL.init AnsiL.Cooked
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = DraftChanged String
    | Recv String
    | Mudline String
    | Send
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DraftChanged draft ->
            ( { model | draft = draft }
            , Cmd.none
            )

        Send ->
            ( { model | draft = "" }
            , sendToMud model.draft
            )

        Recv message ->
            ( { model | inputHistory = model.inputHistory ++ [ message ] }
            , Cmd.none
            )

        Mudline line ->
            -- Debug.log "elm logging"
            ( { model
                | mudlines = parse line ++ model.mudlines
                , ansiModel = AnsiL.update (stringIfNotOOB line) model.ansiModel
              }
            , scrollToBottom
            )

        NoOp ->
            ( model, Cmd.none )


unwrapPrint : Action -> String
unwrapPrint action =
    case action of
        Print value ->
            value

        _ ->
            ""


lineToString : AnsiL.Line -> String
lineToString line =
    let
        ( chunks, _ ) =
            line
    in
    List.map (\chunk -> chunk.text) chunks
        |> String.join ""


isOOB : String -> Bool
isOOB line =
    let
        data =
            List.map unwrapPrint (parse line)
    in
    String.contains "ÿ" (String.join "" data)


stringIfNotOOB : String -> String
stringIfNotOOB mudline =
    case isOOB mudline of
        True ->
            ""

        False ->
            mudline



-- coming in from JS side


subscriptions : Model -> Sub Msg
subscriptions _ =
    sendToElm Mudline


playerView : AnsiL.Model -> AnsiL.Model
playerView model =
    { model | lines = Array.filter (\line -> not <| String.contains "ÿ" (lineToString line)) model.lines }


view : Model -> Html Msg
view model =
    let
        viewModel =
            playerView model.ansiModel
    in
    div
        [ class "container mx-auto bg-gray-900 pl-2", id "mud-content" ]
        [ h1 [ class "connect-title" ] [ text "Echo Chat" ]
        , div [ class "debug" ] []
        , div [ class "text-gray-50 break-words" ] [ AnsiL.view viewModel ]
        , input
            [ type_ "text"
            , placeholder "Draft"
            , onInput DraftChanged
            , on "keydown" (ifIsEnter Send)
            , value model.draft
            , class "-ml-2"
            ]
            []
        , button [ onClick Send ] [ text "Send" ]
        ]



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "some other key"
            )



-- task bc it has dom side effects that could fail
-- pipes whatever scrolly returns into a lil black hole lambda?


scrollToBottom =
    Task.attempt (\_ -> NoOp) <| scrollY "mud-content" 1 1
