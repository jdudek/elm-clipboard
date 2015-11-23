module Example where

import Effects
import Html exposing (Html, div, text, input, button, h1, section)
import Html.Attributes exposing (attribute, id, type', value)
import StartApp
import Task exposing (Task)

import Example.Copy as CopyExample

type alias Model =
  { copyExample : CopyExample.Model
  }

type Action
  = CopyExample CopyExample.Action

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
    (m, fx) = CopyExample.init
  in
    ({ copyExample = m }, Effects.map CopyExample fx)

update action model =
  case action of
    CopyExample a ->
      let
        (m, fx) = CopyExample.update a model.copyExample
      in
        ({ model | copyExample = m }, Effects.map CopyExample fx)

view address model =
  div []
    [ h1 [] [text "elm-clipboard"]
    , section []
      [ h1 [] [text "Copy text from another element"]
      , CopyExample.view (Signal.forwardTo address CopyExample) model.copyExample
      ]
    ]
