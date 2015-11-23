module Clipboard.Attributes where

{-| FIXME docs

@docs clipboardTarget
-}

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as Json
import String
import Clipboard exposing (Action)

{-| FIXME docs
-}
clipboardTarget : String -> Attribute
clipboardTarget selector =
  attribute "data-clipboard-target" selector

{-| FIXME docs
-}
clipboardAction : Action -> Attribute
clipboardAction action =
  let
    actionName = String.toLower (toString action)
  in
    attribute "data-clipboard-action" actionName

onClipboardSuccess address =
  on
    "clipboardSuccess"
    (Json.at ["text"] Json.string)
    (\text -> Signal.message address text)
