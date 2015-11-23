module Example.Copy where

import Effects
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (id, value)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (clipboardTarget)

type alias Model = ()

type Action
  = NoOp

sampleText = "elm package install evancz/elm-http 2.0.0"

init =
  let
    model = ()

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
        [ id "copy"
        , value sampleText
        ] []
    , button
        [ clipboardTarget "#copy" ]
        [ text "Copy" ]
    ]
