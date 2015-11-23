module Example.Event where

import Effects
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (id, value)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (..)
import Timeout exposing (Action(TimedOut))

type alias Model =
  { copied : Bool
  , timeout : Timeout.Model
  }

type Action
  = NoOp
  | ClipboardEvent Clipboard.Event
  | Timeout Timeout.Action

sampleText = "elm package install evancz/elm-http 2.0.0"

init =
  let
    model =
      { copied = False
      , timeout = Timeout.init
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
      let
        (tModel, tFx) = Timeout.start 1000

        model' =
          { model | copied = True, timeout = tModel }
      in
        (model', Effects.map Timeout tFx)

    Timeout TimedOut ->
      ({ model | copied = False }, Effects.none)

    Timeout a ->
      let
        (tModel, tFx) = Timeout.update a model.timeout
      in
        ({ model | timeout = tModel }, Effects.map Timeout tFx)

    NoOp ->
      (model, Effects.none)

view address model =
  let
    status = if model.copied then "Copied!" else ""
  in
    div []
      [ text "Install with:"
      , input
          [ value sampleText ] []
      , button
          [ clipboardText sampleText
          , onClipboardSuccess address ClipboardEvent
          ]
          [ text "Copy" ]
      , text status
      ]