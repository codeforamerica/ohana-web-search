define(
function () {
  'use strict';

  // Detects whether a particular event is supported.
  // (from http://stackoverflow.com/questions/2877393/
  // detecting-support-for-a-given-javascript-event)
  function isEventSupported(eventName) {
    var TAGNAMES = {
      'select': 'input',
      'change': 'input',
      'submit': 'form',
      'reset': 'form',
      'error': 'img',
      'load': 'img',
      'abort': 'img'
    };
    var el = document.createElement(TAGNAMES[eventName] || 'div');
    eventName = 'on' + eventName;
    var isSupported = (eventName in el);
    if (!isSupported) {
      el.setAttribute(eventName, 'return;');
      isSupported = typeof el[eventName] === 'function';
    }
    el = null;
    return isSupported;
  }

  // @return [Object] The client window dimensions.
  // (from http://stackoverflow.com/questions/3333329/
  // javascript-get-browser-height)
  function getWindowRect() {
    var myWidth = 0, myHeight = 0;
    if ( typeof( window.innerWidth ) === 'number' ) {
      //Non-IE
      myWidth = window.innerWidth;
      myHeight = window.innerHeight;
    } else if ( document.documentElement &&
              ( document.documentElement.clientWidth ||
                document.documentElement.clientHeight )
              ) {
      //IE 6+ in 'standards compliant mode'
      myWidth = document.documentElement.clientWidth;
      myHeight = document.documentElement.clientHeight;
    } else if ( document.body &&
              ( document.body.clientWidth || document.body.clientHeight )
              ) {
      //IE 4 compatible
      myWidth = document.body.clientWidth;
      myHeight = document.body.clientHeight;
    }

    return {
      'width':myWidth,
      'height':myHeight
    };
  }

  // Get left and top offset of an element
  // (from http://stackoverflow.com/questions/8111094/
  // cross-browser-javascript-function-to-find-actual-position-of-an-element-
  // in-page)
  // @return [Object] An object with top and left properties.
  function getOffset(element) {
    var body = document.body,
    win = document.defaultView,
    docElem = document.documentElement,
    box = document.createElement('div');
    box.style.paddingLeft = box.style.width = '1px';
    body.appendChild(box);
    var isBoxModel = box.offsetWidth === 2;
    body.removeChild(box);
    box = element.getBoundingClientRect();
    var clientTop  = docElem.clientTop  || body.clientTop  || 0,
        clientLeft = docElem.clientLeft || body.clientLeft || 0,
        scrollTop  = (win && win.pageYOffset) ||
                      isBoxModel && docElem.scrollTop ||
                      body.scrollTop,
        scrollLeft = (win && win.pageXOffset) ||
                      isBoxModel && docElem.scrollLeft ||
                      body.scrollLeft;
    return {
      top : box.top  + scrollTop  - clientTop,
      left: box.left + scrollLeft - clientLeft
    };
  }

  // Get computed style
  // (from http://stackoverflow.com/questions/2664045/
  // how-to-retrieve-a-styles-value-in-javascript)
  function getStyle(el, styleProp) {
    var value, defaultView = (el.ownerDocument || document).defaultView;
    // W3C standard way:
    if (defaultView && defaultView.getComputedStyle) {
      // Sanitize property name to CSS notation
      // (hyphen-separated words eg. font-size).
      styleProp = styleProp.replace(/([A-Z])/g, '-$1').toLowerCase();
      var style = defaultView.getComputedStyle(el, null);
      return style.getPropertyValue(styleProp);
    } else if (el.currentStyle) { // IE
      // sanitize property name to camelCase
      styleProp = styleProp.replace(/\-(\w)/g, function(str, letter) {
        return letter.toUpperCase();
      });
      value = el.currentStyle[styleProp];
      // convert other units to pixels on IE
      if (/^\d+(em|pt|%|ex)?$/i.test(value)) {
        return (function(value) {
          var oldLeft = el.style.left, oldRsLeft = el.runtimeStyle.left;
          el.runtimeStyle.left = el.currentStyle.left;
          el.style.left = value || 0;
          value = el.style.pixelLeft + 'px';
          el.style.left = oldLeft;
          el.runtimeStyle.left = oldRsLeft;
          return value;
        })(value);
      }
      return value;
    }
  }

  // Insert parameters in the URL.
  // @param params [Object] (optional)
  // @return [String] the appended URL query string
  function queryString(params) {
    if (params) {
      var url = document.location.search.substr(1).split('&');
      var urlobj = {};
      var param,key,val;

      for (var p = 0, len = url.length; p < len; p++) {
        param = url[p].split('=');
        key = param[0];
        val = param[1];
        urlobj[key] = val;
      }

      for (key in params) {
        if (params.hasOwnProperty(key))
          urlobj[key] = params[key];
      }

      var str = '';
      val = '';
      for (var k in urlobj) {
        if (k !== '' && urlobj[k] !== '') {
          val = window.escape(window.unescape(k)) + '=' +
                window.escape(window.unescape(urlobj[k]));
          str += val + '&';
        }
      }

      str = '?' + str.substring(0, str.length - 1);

      return str;
    } else {
      return document.location.search;
    }
  }

  // Retrieve named query parameter.
  // (from http://stackoverflow.com/questions/901115/
  // how-can-i-get-query-string-values-in-javascript)
  function getParameterByName(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)'),
    results = regex.exec(location.search);
    var returnVal = '';
    if (results !== null)
      returnVal = decodeURIComponent(results[1].replace(/\+/g, ' '));
    return returnVal;
  }

  return {
    isEventSupported:isEventSupported,
    getWindowRect:getWindowRect,
    getOffset:getOffset,
    getStyle:getStyle,
    queryString:queryString,
    getParameterByName:getParameterByName
  };
});
