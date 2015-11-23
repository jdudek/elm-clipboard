# elm-clipboard

Elm wrapper for http://clipboardjs.com/.


## Installation

At the moment [Elm’s package directory](http://package.elm-lang.org/) requires manual review of libraries with native extensions and this library has not been submitted yet.

Until there is a more elegant way, you need to manually download a copy of the library source code or use Git submodules. You may have a directory like `vendor` and adjust `source-directories` in `elm-package.json` of your project accordingly.

See [elm-hedley](https://github.com/Gizra/elm-hedley) for an example of using vendor packages.


## Usage

* Import `Clipboard` and `Clipboard.Attributes`.
* Pass the task returned from `Clipboard.initialize ()` as an [effect](http://package.elm-lang.org/packages/evancz/elm-effects/latest).
* Add `clipboardText string` attribute to any element.
* You’re all set!

For more complex usage, see attached examples.


## Notes

There’s no support for clearing the selection after user copies the text from an `input` element. I believe there’s little reason for copying directly from an `input` element: just use `clipboardText` and set the value you intend to copy. If you disagree, feel free to create an issue.

The `trigger` property of the event, which is a reference to the clicked DOM node, is not passed along clipboard events. Use action with additional attributes if you need to identify the clicked element, e.g.:

```elm
onClipboardSuccess address (ClipboardEvent identifier)
```

## License

MIT.
