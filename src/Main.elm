port module Main exposing (..)

import Ansi exposing (Action(..), parse)
import Ansi.Log as AnsiL
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Scroll exposing (scrollY)
import Task



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


scrollToBottom =
    Task.attempt (\_ -> NoOp) <| scrollY "mud-content" 1 1


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
                , ansiModel = AnsiL.update line model.ansiModel
              }
            , scrollToBottom
            )

        NoOp ->
            ( model, Cmd.none )



-- coming in from JS side


subscriptions : Model -> Sub Msg
subscriptions _ =
    sendToElm Mudline


view : Model -> Html Msg
view model =
    div
        [ class "container mx-auto w-full h-full bg-gray-900 pl-2", id "mud-content" ]
        [ h1 [ class "connect-title" ] [ text "Echo Chat" ]
        , div [ class "text-gray-50" ] [ AnsiL.view model.ansiModel ]
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
