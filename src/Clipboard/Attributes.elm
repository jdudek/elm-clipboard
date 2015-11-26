module Clipboard.Attributes
  ( clipboardText
  , clipboardTarget
  , clipboardAction
  , onClipboardSuccess
  , onClipboardError
  ) where

{-| This file is intended to be imported with `exposing(..)`, hence all
functions are prefixed.

@docs clipboardText, clipboardTarget, clipboardAction

# Events

@docs onClipboardSuccess, onClipboardError
-}

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as Json exposing (Decoder, (:=))
import String
import Clipboard exposing (Action(..), Success, Error)

{-| Sets the text that will be copied to clipboard when element is clicked.
-}
clipboardText : String -> Attribute
clipboardText text =
  attribute "data-clipboard-text" text

{-| Sets the target element, from which text will be copied (or cut) to
clipboard when element is clicked.

Note you can only cut text from `input` and `textarea` elements.
-}
clipboardTarget : String -> Attribute
clipboardTarget selector =
  attribute "data-clipboard-target" selector

{-| Sets an action to perform when clicked: copy or cut.
-}
clipboardAction : Action -> Attribute
clipboardAction action =
  let
    actionName = String.toLower (toString action)
  in
    attribute "data-clipboard-action" actionName

{-| Event triggered when copying/cutting was successful.
-}
onClipboardSuccess : Signal.Address a -> (Success -> a) -> Html.Attribute
onClipboardSuccess address toAction =
  on
    "clipboardSuccess"
    decodeSuccess
    (\success -> Signal.message address (toAction success))

{-| Event triggered when copying/cutting failed.
-}
onClipboardError : Signal.Address a -> (Error -> a) -> Html.Attribute
onClipboardError address toAction =
  on
    "clipboardError"
    decodeError
    (\error -> Signal.message address (toAction error))


-- Decoders

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
