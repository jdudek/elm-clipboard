module Example.Text where

import Effects
import Html exposing (Html, div, text, input, button, span)
import Html.Attributes exposing (id, type', value, class)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (..)

type alias Model =
  ()

type Action = NoOp

sampleText = "elm package install evancz/elm-http 2.0.0"

init =
  let
    model =
      ()

    fx =
      Effects.task <|
        Clipboard.initialize ()
        `andThen` (\_ -> succeed NoOp)
        `onError` (\_ -> succeed NoOp)
  in
    (model, fx)

update action model =
  case action of
    NoOp ->
      (model, Effects.none)

view address model =
  span [ class "input-group" ]
    [ input
        [ type' "text", value sampleText ] []
    , span [ class "input-group-button" ]
      [ button
        [ clipboardText sampleText
        , class "btn"
        ]
        [ span [ class "octicon octicon-clippy" ] []
        ]
      ]
    ]

code = """
sampleText = "elm package install evancz/elm-http 2.0.0"

view address model =
  span []
    [ input
        [ type' "text"
        , value sampleText
        ] []
    , button
        [ clipboardText sampleText ]
        [ text "Copy" ]
    ]
"""
