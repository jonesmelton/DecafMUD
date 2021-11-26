port module Main exposing (..)

import Ansi exposing (Action(..), parse)
import Ansi.Log as AnsiL
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



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
    | Send
    | Recv String
    | Mudline String



-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--


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
            , Cmd.none
            )



-- coming in from JS side


subscriptions : Model -> Sub Msg
subscriptions _ =
    sendToElm Mudline


view : Model -> Html Msg
view model =
    div [ class "container mx-auto w-full h-full" ]
        [ h1 [ class "connect-title" ] [ text "Echo Chat" ]
        , AnsiL.view model.ansiModel
        , input
            [ type_ "text"
            , placeholder "Draft"
            , onInput DraftChanged
            , on "keydown" (ifIsEnter Send)
            , value model.draft
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
