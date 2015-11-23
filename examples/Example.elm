module Example where

import Effects
import Html exposing (Html, div, text, input, button, h1, section)
import Html.Attributes
import StartApp
import Task exposing (Task)

import Example.Copy as CopyExample
import Example.Event as EventExample
import Example.Cut as CutExample
import Example.Text as TextExample

type alias Model =
  { copyExample  : CopyExample.Model
  , eventExample : EventExample.Model
  , cutExample   : CutExample.Model
  , textExample  : TextExample.Model
  }

type Action
  = CopyExample  CopyExample.Action
  | EventExample EventExample.Action
  | CutExample   CutExample.Action
  | TextExample  TextExample.Action

app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks

init =
  let
    mapFx action (model, fx) =
      (model, Effects.map action fx)

    ((m1, fx1), (m2, fx2), (m3, fx3), (m4, fx4)) =
      ( CopyExample.init  |> mapFx CopyExample
      , EventExample.init |> mapFx EventExample
      , CutExample.init   |> mapFx CutExample
      , TextExample.init  |> mapFx TextExample
      )

    model =
      { copyExample = m1
      , eventExample = m2
      , cutExample = m3
      , textExample = m4
      }

    fx =
      Effects.batch [fx1, fx2, fx3, fx4]
  in
    (model, fx)

update action model =
  case action of
    CopyExample a ->
      let
        (m, fx) = CopyExample.update a model.copyExample
      in
        ({ model | copyExample = m }, Effects.map CopyExample fx)

    EventExample a ->
      let
        (m, fx) = EventExample.update a model.eventExample
      in
        ({ model | eventExample = m }, Effects.map EventExample fx)

    CutExample a ->
      let
        (m, fx) = CutExample.update a model.cutExample
      in
        ({ model | cutExample = m }, Effects.map CutExample fx)

    TextExample a ->
      let
        (m, fx) = TextExample.update a model.textExample
      in
        ({ model | textExample = m }, Effects.map TextExample fx)

view address model =
  div []
    [ h1 [] [text "elm-clipboard"]
    , section []
      [ h1 [] [text "Copy text from attribute"]
      , TextExample.view (Signal.forwardTo address TextExample) model.textExample
      ]
    , section []
      [ h1 [] [text "Event triggered after successful copying"]
      , EventExample.view (Signal.forwardTo address EventExample) model.eventExample
      ]
    , section []
      [ h1 [] [text "Copy text from another element"]
      , CopyExample.view (Signal.forwardTo address CopyExample) model.copyExample
      ]
    , section []
      [ h1 [] [text "Cut text from another element"]
      , CutExample.view (Signal.forwardTo address CutExample) model.cutExample
      ]
    ]
