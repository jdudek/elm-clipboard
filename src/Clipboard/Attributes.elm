module Clipboard.Attributes where

{-| FIXME docs

@docs clipboardTarget
-}

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as Json exposing (Decoder, (:=))
import String
import Clipboard exposing (Action(..), Success, Error)

{-| FIXME docs
-}
clipboardTarget : String -> Attribute
clipboardTarget selector =
  attribute "data-clipboard-target" selector

{-| FIXME docs
-}
clipboardText : String -> Attribute
clipboardText text =
  attribute "data-clipboard-text" text

{-| FIXME docs
-}
clipboardAction : Action -> Attribute
clipboardAction action =
  let
    actionName = String.toLower (toString action)
  in
    attribute "data-clipboard-action" actionName

onClipboardSuccess : Signal.Address a -> (Success -> a) -> Html.Attribute
onClipboardSuccess address toAction =
  on
    "clipboardSuccess"
    decodeSuccess
    (\success -> Signal.message address (toAction success))

onClipboardError : Signal.Address a -> (Error -> a) -> Html.Attribute
onClipboardError address toAction =
  on
    "clipboardError"
    decodeError
    (\error -> Signal.message address (toAction error))

decodeSuccess : Decoder Success
decodeSuccess =
  Json.object2 Success
    ("text" := Json.string)
    ("action" := decodeAction)

decodeError : Decoder Error
decodeError =
  Json.object1 Error
    ("action" := decodeAction)

decodeAction : Decoder Action
decodeAction =
  let
    toAction s =
      case s of
        "copy" ->
          Json.succeed Copy

        "cut" ->
          Json.succeed Cut

        _ ->
          Json.fail ("Unknown clipboard action " ++ s)
  in
    Json.string `Json.andThen` toAction
