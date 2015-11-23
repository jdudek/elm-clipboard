module Clipboard (initialize, Event, Action(..)) where

{-| FIXME docs

@docs initialize, Event, Action
-}

import Task exposing (Task)
import Native.Clipboard

{-| FIXME docs
-}
type alias Event = String

{-| FIXME docs
-}
type Action = Copy | Cut

{-| FIXME docs
-}
initialize : () -> Task x ()
initialize = Native.Clipboard.initialize
