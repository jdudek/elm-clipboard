module Example.Event where

import Effects
import Html exposing (Html, div, text, input, button, span)
import Html.Attributes exposing (id, type', value, class, attribute)
import Html.Events exposing (onMouseLeave)
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Clipboard.Attributes exposing (..)

type alias Model =
  { copied : Bool
  }

type Action
  = NoOp
  | ClipboardSuccess Clipboard.Success
  | ClearCopied

sampleText = "elm package install evancz/elm-http 2.0.0"

init =
  let
    model =
      { copied = False
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
    ClipboardSuccess e ->
      ({ model | copied = True }, Effects.none)

    ClearCopied ->
      ({ model | copied = False }, Effects.none)

    NoOp ->
      (model, Effects.none)

view address model =
  let
    tooltipAttrs =
      [ class "btn tooltipped tooltipped-s"
      , attribute "aria-label" "Copied!"
      ]

    buttonWithTooltip attrs content =
      button (attrs ++ tooltipAttrs) content
  in
    span [ class "input-group" ]
      [ input
          [ type' "text"
          , value sampleText
          ] []
      , span [ class "input-group-button" ]
        [ (if model.copied then buttonWithTooltip else button)
            [ clipboardText sampleText
            , onClipboardSuccess address ClipboardSuccess
            , onMouseLeave address ClearCopied
            , class "btn"
            ]
            [ span [ class "octicon octicon-clippy" ] [] ]
        ]
      ]
