module Example where

import Effects
import Html exposing (Html, div, p, a, text, input, button, h1, h2, section, pre, code)
import Html.Attributes exposing (class, href)
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
  let
    forward fn = Signal.forwardTo address fn
  in
    container
      [ h1 [] [ text "elm-clipboard" ]
      , lead
      , section []
          [ h2 [] [ text "Copy text from attribute" ]
          , p [] [ linkToSample "Example/Text.elm" ]
          , TextExample.view (forward TextExample) model.textExample
          , codeSample TextExample.code
          ]
      , section []
          [ h2 [] [ text "Event triggered after successful copying" ]
          , p [] [ linkToSample "Example/Event.elm" ]
          , EventExample.view (forward EventExample) model.eventExample
          ]
      , section []
          [ h2 [] [text "Copy text from another element"]
          , p [] [ linkToSample "Example/Copy.elm" ]
          , CopyExample.view (forward CopyExample) model.copyExample
          , codeSample CopyExample.code
          ]
      , section []
          [ h2 [] [text "Cut text from another element"]
          , p [] [ linkToSample "Example/Cut.elm" ]
          , CutExample.view (forward CutExample) model.cutExample
          ]
      ]

container content =
  div [ class "container" ]
    [ div [ class "columns" ]
      [ div [ class "three-fourths centered" ]
        content
      ]
    ]

lead =
  p [ class "lead" ]
    [ text "elm-clipboard is an "
    , a [ href "http://elm-lang.org/"] [ text "Elm" ]
    , text " wrapper for "
    , a [ href "http://clipboardjs.com/"] [ text "Clipboard.js" ]
    , text ". See the "
    , a [ href "https://github.com/jdudek/elm-clipboard" ]
        [ text "README" ]
    , text " file for more details."
    ]

codeSample string =
  pre []
    [ code [ class "elm" ] [ text string ]
    ]

linkToSample file =
  let
    url = "https://github.com/jdudek/elm-clipboard/blob/master/examples/" ++ file
  in
    a [ href url ] [ text "Full example" ]
