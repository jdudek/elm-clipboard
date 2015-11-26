module Clipboard
  ( initialize
  , Success
  , Error
  , Action(..)
  ) where

{-|
@docs initialize, Action, Success, Error
-}

import Task exposing (Task)
import Native.Clipboard

{-| Represents one of two possible actions: copying or cutting text. If omitted,
will copy by default. Note that cutting text is only possible in combination
with `clipboardTarget`, not when setting text to copy directly via
`clipboardText`.
-}
type Action = Copy | Cut

{-| Event triggered when copied/cut successfully.
-}
type alias Success =
  { text : String
  , action : Action
  }

{-| Event triggered when couldn’t copy or cut.
-}
type alias Error =
  { action : Action
  }

{-| Initializes the library. Needs to be called at least once.
Wrap it in `Effects` and run in your `init` function.
-}
initialize : () -> Task x ()
initialize = Native.Clipboard.initialize
