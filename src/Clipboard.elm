module Clipboard
  ( initialize
  , Success
  , Error
  , Action(..)
  ) where

{-| FIXME docs

@docs initialize, Success, Error, Action
-}

import Task exposing (Task)
import Native.Clipboard

{-| FIXME docs
-}
type Action = Copy | Cut

{-| FIXME docs
-}
type alias Success =
  { text : String
  , action : Action
  }

{-| FIXME docs
-}
type alias Error =
  { action : Action
  }

{-| FIXME docs
-}
initialize : () -> Task x ()
initialize = Native.Clipboard.initialize
