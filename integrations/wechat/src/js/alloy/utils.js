/* 
 Created on : 2015-5-11, 09:23:21
 Author     : zhaoqiying
 */

/**
 * Extends
 */

WebApp.Utils = {
    toReverse: function (number,fix) {
        //var parsePercent = Math.round(parseFloat(number));
        var parsePercent = parseFloat(number).toFixed(fix);
        return (!parsePercent ? 0 : parsePercent);
    }
};

WebApp.Terminal = {
    platform: (function () {
        var u = navigator.userAgent, app = navigator.appVersion;
        return {
            // 是否为Android
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1,
            // 是否为iPhone
            iPhone: u.indexOf('iPhone') > -1 || /(iPhone|iPod|iOS)/i.test(u.userAgent) || !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),
            // 是否iPad
            iPad: u.indexOf('iPad') > -1 || /(iPad)/i.test(u.userAgent),
            // 是否微信
            weChat: u.indexOf('MicroMessenger') > -1
        };
    })(),
    // 终端的语言
    language: (navigator.browserLanguage || navigator.language).toLowerCase()
};

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

(function () {

    /**
     * Extends the Function.prototype object with the following utility methods if they don't already exis
     */
    var extensions = {
        /**
         * Function#bind(context)   --> Function
         *
         * Binds this function to the context specified as the first argument. It wraps the original function in a
         * new one that is returned. This ensures that object methods or event callbacks are bound to their respective
         * contexts when executing
         *
         * @return a function bound to the context specified and wrapping the original function
         */
        bind: function () {
            if (arguments.length < 2 && angular.isUndefined(arguments[0])) {
                return this;
            }

            var _method = this, slice = Array.prototype.slice,
                    args = slice.apply(arguments),
                    context = args.shift();

            return function () {
                return _method.apply(context, args.concat(slice.apply(arguments)));
            };
        },
        /**
         * Function#curry(arguments) --> Function
         *
         * Returns a function that prepopulates some parameters with the arguments specified. When the function is
         * invoked, its final list of arguments will be a collection of the curried arguments and the new ones passed
         * to the returned function
         *
         * @return a curried function that contains pre-filled arguments
         */
        curry: function () {
            if (!arguments.length) {
                return this;
            }

            var _method = this, slice = Array.prototype.slice,
                    args = slice.apply(arguments);

            return function () {
                return _method.apply(this, args.concat(slice.apply(arguments)));
            };
        },
        /**
         * Function#delay(number)  --> Function
         *
         * Returns a function that wraps the original function in a timer (in seconds). The function can be bound to
         * its execution context using Function#bind and will execute after the timer elapses
         *
         * @return a wrapper function that will execute after the timer has elapsed
         */
        delay: function () {
            var _method = this, slice = Array.prototype.slice,
                    args = slice.apply(arguments),
                    timeout = args.shift() * 1000;
            return setTimeout(function () {
                return _method.apply(_method, args);
            }, timeout);
        },
        /**
         * Function#defer() --> Function
         *
         * Returns a function that wraps the original function in a default timer of 10ms. This is a convenience
         * implementation of Function#delay that ensures that a function is invoked last
         *
         * @return a wrapper function that will execute after 10ms
         */
        defer: function () {
            var args = [0.01].concat(Array.prototype.slice(arguments));
            return this.delay.apply(this, args);
        }
    };

    for (var method in extensions) {
        if (!Function.prototype[method]) {
            Function.prototype[method] = extensions[method];
        }
    }

})();