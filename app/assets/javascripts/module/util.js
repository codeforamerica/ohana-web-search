define(function() {
  'use strict';
	
		// return the client window dimensions.
		// (from http://stackoverflow.com/questions/3333329/javascript-get-browser-height)
		function getWindowRect()
		{
  		var myWidth = 0, myHeight = 0;
		  if( typeof( window.innerWidth ) == 'number' ) 
		  {
		    //Non-IE
		    myWidth = window.innerWidth;
		    myHeight = window.innerHeight;
		  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
		    //IE 6+ in 'standards compliant mode'
		    myWidth = document.documentElement.clientWidth;
		    myHeight = document.documentElement.clientHeight;
		  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
		    //IE 4 compatible
		    myWidth = document.body.clientWidth;
		    myHeight = document.body.clientHeight;
		  }

		  return {"width":myWidth,"height":myHeight}
		}

		// get left and top offset of an element
		// (from http://stackoverflow.com/questions/442404/dynamically-retrieve-the-position-x-y-of-an-html-element)
		function getOffset( el ) 
		{
		    var _x = 0;
		    var _y = 0;
		    while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
		        _x += el.offsetLeft - el.scrollLeft;
		        _y += el.offsetTop - el.scrollTop;
		        el = el.offsetParent;
		    }
		    return { top: _y, left: _x };
		}

		// @return [Object] browser-appropriate requestanimationframe implementation
		// @example util.requestAnimationFrame()(_animate_callback);
		function requestAnimationFrame()
		{
					return window.webkitRequestAnimationFrame ||
					window.mozRequestAnimationFrame ||
					window.oRequestAnimationFrame ||
					window.msRequestAnimationFrame 
		}


		// get computed style 
		// (from http://stackoverflow.com/questions/2664045/how-to-retrieve-a-styles-value-in-javascript)
		function getStyle(el, styleProp) {
		  var value, defaultView = (el.ownerDocument || document).defaultView;
		  // W3C standard way:
		  if (defaultView && defaultView.getComputedStyle) {
		    // sanitize property name to css notation
		    // (hypen separated words eg. font-Size)
		    styleProp = styleProp.replace(/([A-Z])/g, "-$1").toLowerCase();
		    return defaultView.getComputedStyle(el, null).getPropertyValue(styleProp);
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
		        value = el.style.pixelLeft + "px";
		        el.style.left = oldLeft;
		        el.runtimeStyle.left = oldRsLeft;
		        return value;
		      })(value);
		    }
		    return value;
		  }
		}

		// insert parameters in the URL
		// @param params [Object] (optional)
		// @return [String] the appended URL query string
		function queryString(params)
		{
			if (params)
			{
				var url = document.location.search.substr(1).split('&');
				var urlobj = {};
				var param,key,val;

				for (var p in url)
			  {
			  	param = url[p].split('=');
			  	key = param[0];
			  	val = param[1];
			  	urlobj[key] = val;
			  }

				for (var key in params) 
				{
					urlobj[key] = params[key];
				}

				var str = '';
				var val = '';
				for (var k in urlobj)
			  {
			  	if (k != '' && urlobj[k] != '')
			  	{
			  		val = escape(unescape(k))+'='+escape(unescape(urlobj[k]));
			  		str += val+'&';
			  	}
			  }

			  str = '?'+str.substring(0, str.length-1);

			  return str;
			}
			else
			{
				return document.location.search;
			}
		}

	return {
		getWindowRect:getWindowRect,
		getOffset:getOffset,
		requestAnimationFrame:requestAnimationFrame,
		getStyle:getStyle,
		queryString:queryString
	};
});