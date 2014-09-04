// Manages behavior of the Google Website Translator Gadget.
define([
  'util/translation/layout/DropDownLayout'
],
function (DropDownLayout) {
  'use strict';

  // The layout object in use.
  var _layout;

  // The current layout that is set. Determined by the
  // 'layout' setting in the Google Translate provided script
  // in the footer.
  var _layoutType;

  // Same 'constants' as google.translate.TranslateElement.InlineLayout
  // for tracking which layout is in use.
  var VERTICAL = 0;
  var HORIZONTAL = 1;
  var InlineLayout = { VERTICAL:VERTICAL, HORIZONTAL:HORIZONTAL };

  // The id of the element on the page that will contain
  // the Google Website Translator Gadget.
  var GOOGLE_TRANSLATE_ELEMENT_ID = 'google-translate-container';

  function init(layoutType) {
    _layoutType = layoutType;

    _deleteTranslateCookies();

    _layout = DropDownLayout.create();
    _layout.init(GOOGLE_TRANSLATE_ELEMENT_ID);

    // Add Google Translate script call by appending script element.
    var scriptElm = document.createElement('script');
    var scriptUrl = '//translate.google.com/translate_a/element.js?cb=';
    var scriptCallback = 'GoogleTranslate.googleTranslateElementInit';
    scriptElm.setAttribute('src', scriptUrl+scriptCallback);
    document.body.appendChild(scriptElm);

    // Add the callback function for the Google Translate script.
    var GoogleTranslate = {
      googleTranslateElementInit:_googleTranslateElementInit
    };
    window.GoogleTranslate = GoogleTranslate;
  }

  // Initialize the Google Website Translator Gadget.
  function _googleTranslateElementInit() {
    var opts = {
      pageLanguage: 'en',
      layout: _getGoogleLayout(),
      autoDisplay: false
    };

    new google.translate.TranslateElement( opts, GOOGLE_TRANSLATE_ELEMENT_ID );

    // Activate hooks to manipulate Google Website Translator Gadget through
    // the URL 'translate' parameter.
    _layout.activate();
  }

  // @return [Object] Return the inline Google Website Translator Gadget
  // layouts supplied by Google.
  function _getGoogleLayout() {
    if (_layoutType === VERTICAL)
      return google.translate.TranslateElement.InlineLayout.VERTICAL;
    else if (_layoutType === HORIZONTAL)
      return google.translate.TranslateElement.InlineLayout.HORIZONTAL;
  }

  // Removes the Google Website Translator cookies by setting their expiration
  // date into the past.
  function _deleteTranslateCookies() {
   var cookies, cookie, eqPos, name;
    cookies = document.cookie.split('; ');
    for (var i = 0, len = cookies.length; i < len; i++) {
      cookie = cookies[i];
      eqPos = cookie.indexOf('=');
      name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
      if (name === 'googtrans')
        document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:00 GMT';
    }
  }

  return {
    init:init,
    InlineLayout:InlineLayout
  };
});
