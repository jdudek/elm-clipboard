module Example.Cut where

import Effects
import Html exposing (Html, div, text, input, button, span)
import Html.Attributes exposing (id, type', value, class)
import Html.Events exposing (onClick)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (..)

type alias Model =
  { text : String
  }

type Action
  = NoOp
  | ClipboardEvent Clipboard.Event
  | Reset

initialText = "elm package install evancz/elm-http 2.0.0"

init =
  let
    model =
      { text = initialText
      }

    fx =
      Effects.task <|
        Clipboard.initialize ()
        `andThen` (\_ -> succeed NoOp)
        `onError` (\_ -> succeed NoOp)
  in
    (model, fx)

update action model =
  case action of
    ClipboardEvent e ->
      ({ model | text = "" }, Effects.none)

    Reset ->
      ({ model | text = initialText }, Effects.none)

    NoOp ->
      (model, Effects.none)

view address model =
  div []
    [ input
        [ type' "text"
        , id "cut"
        , value model.text
        , class "input-block"
        ] []
    , div [ class "text-right" ]
      [ div [ class "btn-group" ]
        [ button
            [ clipboardTarget "#cut"
            , clipboardAction Clipboard.Cut
            , onClipboardSuccess address ClipboardEvent
            , class "btn"
            ]
            [ text "Cut" ]
        , button
            [ onClick address Reset, class "btn" ]
            [ text "Reset" ]
        ]
      ]
    ]
