module Example.Text where

import Effects
import Html exposing (Html, div, text, input, button, h1, section)
import Html.Attributes exposing (id, type', value)
import Html.Events exposing (onClick)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (..)

type alias Model =
  { text : String
  }

type Action
  = NoOp

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
  div []
    [ text "Install with:"
    , input
        [ value sampleText ] []
    , button
        [ clipboardText sampleText ]
        [ text "Copy" ]
    ]
