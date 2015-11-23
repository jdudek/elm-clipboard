module Example where

import Effects
import Html exposing (Html, div, text, input, button, h1, section)
import Html.Attributes
import StartApp
import Task exposing (Task)

import Example.Copy as CopyExample
import Example.Cut as CutExample

type alias Model =
  { copyExample : CopyExample.Model
  , cutExample : CutExample.Model
  }

type Action
  = CopyExample CopyExample.Action
  | CutExample CutExample.Action

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
    (m1, fx1) =
      CopyExample.init

    (m2, fx2) =
      CutExample.init

    model =
      { copyExample = m1
      , cutExample = m2
      }

    fx =
      Effects.batch
        [ Effects.map CopyExample fx1
        , Effects.map CutExample fx2
        ]
  in
    (model, fx)

update action model =
  case action of
    CopyExample a ->
      let
        (m, fx) = CopyExample.update a model.copyExample
      in
        ({ model | copyExample = m }, Effects.map CopyExample fx)

    CutExample a ->
      let
        (m, fx) = CutExample.update a model.cutExample
      in
        ({ model | cutExample = m }, Effects.map CutExample fx)

view address model =
  div []
    [ h1 [] [text "elm-clipboard"]
    , section []
      [ h1 [] [text "Copy text from another element"]
      , CopyExample.view (Signal.forwardTo address CopyExample) model.copyExample
      ]
    , section []
      [ h1 [] [text "Cut text from another element"]
      , CutExample.view (Signal.forwardTo address CutExample) model.cutExample
      ]
    ]
