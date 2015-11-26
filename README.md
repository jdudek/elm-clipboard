# elm-clipboard

Elm wrapper for [Clipboard.js](http://clipboardjs.com/).

[Live demo](http://jdudek.github.io/elm-clipboard/).

## Installation

At the moment [Elm’s package directory](http://package.elm-lang.org/) requires manual review of libraries with native extensions and this library has not been submitted yet.

Until there is a more elegant way, you need to manually download a copy of the library source code or use Git submodules. Create a directory like `vendor` and adjust `source-directories` in `elm-package.json` of your project accordingly.

See [elm-hedley](https://github.com/Gizra/elm-hedley) for an example of using vendor packages with native extensions.


## Usage

* Import `Clipboard` and `Clipboard.Attributes`.
* Pass the task returned from `Clipboard.initialize ()` as an [effect](http://package.elm-lang.org/packages/evancz/elm-effects/latest).
* Add `clipboardText string` attribute to any element.
* You’re all set! Clicking the element will copy given string to clipboard.


## Example

Below is a minimal example. You can find more complex examples [here](http://jdudek.github.io/elm-clipboard/).

```elm
module Example where

import Effects
import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task, andThen, onError, succeed)
import StartApp

import Clipboard
import Clipboard.Attributes exposing (..)

type Action = NoOp

app =
  StartApp.start
    { init = init , view = view , update = update , inputs = [] }

main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks

init =
  let
    model = ()

    fx =
      Effects.task <|
        Clipboard.initialize ()
        `andThen` (\_ -> succeed NoOp)
        `onError` (\_ -> succeed NoOp)
  in
    (model, fx)

update action model =
  case action of
    NoOp ->
      (model, Effects.none)

view address model =
  span []
    [ button
        [ clipboardText "Text to copy" ]
        [ text "Copy" ]
    ]

```


## Notes

There’s no support for clearing the selection after user copies the text from an `input` element. I believe there’s little reason for copying directly from an `input` element: just use `clipboardText` and set the value you intend to copy. If you disagree, feel free to create an issue.

The `trigger` property of the event, which is a reference to the clicked DOM node, is not passed along clipboard events. Use action with additional attributes if you need to identify the clicked element, e.g.:

```elm
onClipboardSuccess address (ClipboardEvent identifier)
```

## Updating Clipboard.js

Bump the version number of `clipboard` in package.json and run `npm run build`.

## License

MIT.
