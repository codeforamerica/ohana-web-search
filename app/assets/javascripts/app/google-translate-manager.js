// Manages behavior of google translate drop-down
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

  // Removes the google translate cookies by setting their expiration date
  // into the past.
  function _deleteTranslateCookies() {
    var cookies = document.cookie.split(";");

    for (var i = 0; i < cookies.length; i++) {
      var cookie = cookies[i];
      var eqPos = cookie.indexOf("=");
      var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
      if (name === "googtrans")
        document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
  }

  // Polling check for Google Translate drop-down to be initialized
  function _checkForGoog()
  {
    // timeout check set to 20 seconds
    if (_timeoutCount++ < 20)
    {
      setTimeout(function(){
        _languages = document.querySelector('#google-translate-element select');
        if (!_languages) _checkForGoog();
        else _hookDropDown();
      },1000);
    }
    else
    {
      console.log("Timeout while initializing Google Translate drop-down!");
    }
  }

  // Hook in a change event to the language drop-down menu so the page reloads
  // and is appended a translate query string when the drop-down menu is changed.
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