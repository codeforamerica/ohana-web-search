// manages behavior of google translate drop-down
define(['util/util'],function(util) {
  'use strict';

		// PRIVATE PROPERTIES
    var _languages;
    var _timeoutCount = 0;

		// PUBLIC METHODS
		function init()
		{
      _deleteTranslateCookies();
      _checkForGoog();
		}

    function _deleteTranslateCookies() {
        var cookies = document.cookie.split(";");

        for (var i = 0; i < cookies.length; i++) {
          var cookie = cookies[i];
          var eqPos = cookie.indexOf("=");
          var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
          if (name == "googtrans")
            document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
        }
    }

    function _checkForGoog()
    {
      // Polling check for Google Translate drop-down to be initialized
      // Set to 7 seconds (same as RequireJS timeout wait time)
      if (_timeoutCount++ < 7)
      {
        setTimeout(function(){
          _languages = document.querySelector('#google_translate_element select');
          if (!_languages) _checkForGoog();
          else _hookDropDown();
        },1000);
      }
      else
      {
        console.log("Timeout while initializing Google Translate drop-down!");
      }
    }

    function _hookDropDown()
    {
      _languages.addEventListener('change',_langUpdated,false);
    }

    function _langUpdated(evt)
    {
      document.location.search = util.queryString({"translate":_languages.options[_languages.selectedIndex].value});
    }

	return {
		init:init
	};
});