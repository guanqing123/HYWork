/**
 * 扩展函数
 * @returns {Function}
 */
Function.prototype.createDelegate = function(obj) {
    var method = this;
    var args = arguments[1];
    var appendArgs = arguments[2];
    return function () {
        var callArgs = args || arguments;
        if (appendArgs === true) {
            callArgs = Array.prototype.slice.call(arguments, 0);
            callArgs = callArgs.concat(args);
        } else if (typeof appendArgs == "number") {
            callArgs = Array.prototype.slice.call(arguments, 0);
            // copy arguments first
            var applyArgs = [appendArgs, 0].concat(args);
            // create method call params
            Array.prototype.splice.apply(callArgs, applyArgs);
            // splice them in
        }
        return method.apply(obj, callArgs);
    };
};

/**
 * 定义FR对象
 */
FR = {};

FR.tc = function(fn, context) {
    try {
        return fn.call(context);
    } catch (e) {
        log(e);
        throw e;
    }
};

FR.ajax = function(options) {
    var success = options.success;
    var error = options.error;
    var complete = options.complete;
    FR.ajax4Mobile(options, success, error, complete);
};

FR.i18nText = function(t) {
    return t;
};

/**
 * 定义FR的消息对象
 */
FR.Msg = {};

FR.Form = function() {
    return FR.currentReport();
}

_g = function() {
    return FR.currentReport();
}

FR.Chart = {};

FR.Chart.WebUtils = {};

FR.Chart.WebUtils.getChart = function(widgetName) {
    return FR.currentReport().getWidgetByName(widgetName);
}

window = {};

window.FR = FR;

setTimeout = window.setTimeout = function(fn, time) {
    return FR.setTimeout(fn, time);
}

clearTimeout = window.clearInterval = function(timer) {
    FR.clearTimeout(timer);
}

setInterval = window.setInterval = function(fn, time) {
    return FR.setInterval(fn, time);
}

clearInterval = window.clearInterval = function(timer) {
    FR.clearInterval(timer);
}

self = window;

self.location = {};

self.location.reload = function() {
    location.reload();
}