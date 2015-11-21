module Example where

import Effects
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (attribute, id, type', value)
import StartApp
import Task exposing (Task, andThen, onError, succeed)

import Clipboard
import Timeout exposing (Action(TimedOut))

type alias Model =
  { copied : Bool
  , timeout : Timeout.Model
  }

type Action
  = NoOp
  | ClipboardEvent Clipboard.Event
  | Timeout Timeout.Action

app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = [ clipboardActions ]
    }

main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks

clipboardEvents : Signal.Mailbox (Maybe Clipboard.Event)
clipboardEvents = Signal.mailbox Nothing

clipboardActions =
  let
    f x = case x of
      Just e -> ClipboardEvent e
      Nothing -> NoOp
  in
    Signal.map f clipboardEvents.signal

init =
  let
    model =
      { copied = False
      , timeout = Timeout.init
      }

    fx =
      Effects.task <|
        Clipboard.initialize
          "[data-clipboard-target]"
          (Signal.forwardTo clipboardEvents.address Just)
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

view _ model =
  let
    status = if model.copied then "Copied!" else ""
  in
    div []
      [ text "Install with:"
      , input
          [ type' "text"
          , id "install-command"
          , value "elm package install evancz/elm-http 2.0.0"
          ] []
      , button
          [ attribute "data-clipboard-target" "#install-command" ]
          [ text "Copy" ]
      , text status
      ]
