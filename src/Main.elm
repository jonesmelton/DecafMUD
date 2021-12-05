port module Main exposing (..)

import Ansi exposing (Action(..), parse)
import Ansi.Log as AnsiL
import Browser
import Browser.Dom as Dom
import Discworld as DW
import Discworld.Parse exposing (mudData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Scroll exposing (scrollY)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port sendToMud : String -> Cmd msg


port sendToElm : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { draft : String
    , inputHistory : List String
    , mudlines : List Ansi.Action
    , ansiModel : AnsiL.Model
    , infoModel : List String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { draft = ""
      , inputHistory = []
      , mudlines = []
      , ansiModel = AnsiL.init AnsiL.Cooked
      , infoModel = [ "" ]
      }
    , focusInputBox
    )


type Msg
    = DraftChanged String
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
            ( { model
                | draft = ""
                , inputHistory = model.draft :: model.inputHistory
              }
            , sendToMud model.draft
            )

        Mudline line ->
            let
                splitSource =
                    mudData line
            in
            case splitSource of
                ( stream, data ) ->
                    ( { model
                        | infoModel = data :: model.infoModel
                        , ansiModel = AnsiL.update stream model.ansiModel
                      }
                    , scrollToBottom
                    )

        NoOp ->
            ( model, Cmd.none )



-- data sent from the mud that isn't intended for direct human consumption
-- mixed in with the mud output. the library parser doesn't catch it so
-- two different ways to unpack and search text from the mud


applyLineFilters : String -> String
applyLineFilters string =
    filterZMP string


filterZMP : String -> String
filterZMP string =
    String.replace "ÿ" "" string



-- |> Debug.log "replacing"


type MudLine
    = OOB String
    | MudOutput String


divert : String -> MudLine
divert string =
    case isOOB string of
        True ->
            OOB string

        False ->
            MudOutput string


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
    List.map (\ch -> ch.text) chunks
        |> String.join ""


isOOB : String -> Bool
isOOB line =
    let
        data =
            List.map unwrapPrint (parse line)
    in
    String.contains "ÿ" (String.join "" data)



-- coming in from JS side


subscriptions : Model -> Sub Msg
subscriptions _ =
    sendToElm Mudline


playerView : AnsiL.Model -> AnsiL.Model
playerView model =
    -- modify model for views
    -- { model | lines = Array.filter (\line -> not <| String.contains "NAMEDiscworld" (lineToString line)) model.lines }
    model


type alias InfoModel =
    List String


statsView : InfoModel -> Html x
statsView model =
    let
        divClass =
            "fixed bottom-64 right-0 h-256 w-64 z-30 break-words bg-gray-200"

        infoLine ln =
            span [] [ text ln ]
    in
    div
        [ class divClass ]
        [ case model of
            first :: rest ->
                ul []
                    (List.map
                        (\t -> li [] [ text t ])
                        rest
                    )

            [] ->
                text ""
        ]


inputView : Model -> Html Msg
inputView model =
    div [ class "fixed inset-x-0 bottom-0 h-10 bg-blue-100 p-2" ]
        [ input
            [ type_ "text"
            , id "mud-input"
            , placeholder "Draft"
            , onInput DraftChanged
            , on "keydown" (ifIsEnter Send)
            , value model.draft
            , class "left-0"
            ]
            []
        , button [ onClick Send, class "ml-4" ] [ text "Send" ]
        ]


view : Model -> Html Msg
view model =
    let
        viewModel =
            playerView model.ansiModel

        mudContainerClasses =
            "container relative mx-auto bg-gray-900 pl-2 border-double border-4 pb-16"
    in
    div
        [ class mudContainerClasses, id "mud-content" ]
        [ statsView model.infoModel
        , div [ class "text-gray-50 break-words" ] [ AnsiL.view viewModel ]
        , inputView model
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


focusInputBox : Cmd Msg
focusInputBox =
    Task.attempt (\_ -> NoOp) (Dom.focus "mud-input")
