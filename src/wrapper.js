var Clipboard = require('clipboard');

Elm.Native.Clipboard = {};
Elm.Native.Clipboard.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Clipboard = localRuntime.Native.Clipboard || {};

    if (localRuntime.Native.Clipboard.values){
        return localRuntime.Native.Clipboard.values;
    }

    var Task = Elm.Native.Task.make(localRuntime);
    var Utils = Elm.Native.Utils.make(localRuntime);

    var clipboard;

    function initialize(){
        return Task.asyncFunction(function(callback){
            if (clipboard) {
                callback(Task.succeed(Utils.Tuple0));
            }

            clipboard = new Clipboard('[data-clipboard-target], [data-clipboard-text]');

            clipboard.on('success', function (e) {
                if (typeof e.trigger.onclipboardSuccess === 'function') {
                    e.trigger.onclipboardSuccess(e);
                }
            });

            clipboard.on('error', function (e) {
                if (typeof e.trigger.onclipboardError === 'function') {
                    e.trigger.onclipboardError(e);
                }
            });

            callback(Task.succeed(Utils.Tuple0));
        });
    }

    localRuntime.Native.Clipboard.values = {
        initialize: initialize,
    };
    return localRuntime.Native.Clipboard.values;
};
