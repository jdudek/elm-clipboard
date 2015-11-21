module Timeout where

import Effects
import Time exposing (Time)
import Task exposing (Task, succeed)

type alias Model =
  { delay : Int
  , setAt : Maybe Time
  }

type Action = Tick Time | TimedOut

init =
  { delay = 0, setAt = Nothing }

start delay =
  let
    model = { delay = delay, setAt = Nothing }
  in
    (model, Effects.tick Tick)

update action model =
  case action of
    Tick time ->
      case model.setAt of
        Nothing ->
          ({ model | setAt = Just time }, Effects.tick Tick)

        Just prevTime ->
          if time - prevTime > model.delay then
            ({ model | setAt = Nothing }, Effects.task <| succeed TimedOut)
          else
            (model, Effects.tick Tick)

    TimedOut ->
      (model, Effects.none)
