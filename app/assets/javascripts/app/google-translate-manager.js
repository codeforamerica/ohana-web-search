// manages behavior of popups
define(['util/util'],function(util) {
  'use strict';

		// PRIVATE PROPERTIES
    var _languages;
    var _timeoutCount = 0;

		// PUBLIC METHODS
		function init()
		{
      _checkForGoog();
		}

    function _checkForGoog()
    {
      if (_timeoutCount++ < 10)
      {
        setTimeout(function(){
          _languages = document.querySelector('#google_translate_element select');
          if (!_languages) _checkForGoog();
          else _hookDropDown();
        },100);
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
      document.location.search = util.queryString({"translate":_languages.options[_languages.selectedIndex].text.toLowerCase()});
    }

	return {
		init:init
	};
});