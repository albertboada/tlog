// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

(function (window, $) {

function Counter(seconds, $element)
{
    var _interval    = 1,
        _$element    = $element,
        _seconds_src = seconds,
        _seconds     = seconds,
        _event       = null
        _start       = _getTimestamp();

    this.start = function ()
    {
        if (_event == null) {
            _event = window.setInterval(_refreshCounter, _interval * 1000);
        }
    };

    this.stop  = function ()
    {
        if (_event != null) {
            window.clearInterval(_event);
        }
    };

    function _getTimestamp()
    {
        return Math.round(new Date().getTime() / 1000);
    }

    function _refreshCounter()
    {
        var string;

        _refreshSeconds();

        string = _makeCounterString();

        _$element.html(string);
    }

    function _refreshSeconds()
    {
        var now, inc;

        now = _getTimestamp();
        inc = now - _start;

        _seconds = _seconds_src + inc;
    }

    function _makeCounterString()
    {
        var hours, minutes, seconds;

        hours   = window.parseInt(_seconds / 3600);
        seconds = _seconds - (hours * 3600);
        minutes = window.parseInt(seconds / 60);
        seconds = seconds - (minutes * 60);

        return _pad(hours, 2, '0')+"<small>h</small> "+_pad(minutes, 2, '0')+"<small>m</small> "+_pad(seconds, 2, '0')+"<small>s</small>";
    }

    function _pad(n, width, z)
    {
        z = z || '0';
        n = n + '';
        return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }
}

$(function ($) {
    $("[data-counter]").each(function (i, element) {
        var $element, seconds;

        $element = $(element);
        seconds = $element.data("counter");

        new Counter(seconds, $element).start();
    });
});

}(window, window.jQuery));