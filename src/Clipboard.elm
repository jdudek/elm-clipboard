module Clipboard (initialize, Event) where

{-| FIXME docs

@docs initialize, Event
-}

import Task exposing (Task)
import Native.Clipboard

{-| FIXME docs
-}
type alias Event = String

{-| FIXME docs
-}
initialize : String -> Signal.Address Event -> Task x ()
initialize = Native.Clipboard.initialize
