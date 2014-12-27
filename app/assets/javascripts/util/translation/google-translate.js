// Manages behavior of the Google Website Translator Gadget.
define([
  'util/util',
  'util/cookie',
  'util/translation/layout/DropDownLayout'
],
function (util, cookie, DropDownLayout) {
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

    _writeTranslateCookies();

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

  // Checks if the 'googtrans' cookie is set to English or not,
  // indicating whether the page has been translated using the
  // Google Website Translator Gadget.
  // @return [Boolean] true if Google Translation has translated the page.
  // Returns false if the page is not translated and is in English.
  function isTranslated() {
    var googtrans = cookie.read('googtrans');
    return (googtrans && decodeURIComponent(googtrans) !== '/en/en');
  }

  // Initialize the Google Website Translator Gadget.
  function _googleTranslateElementInit() {
    var gadgetOptions = {
      pageLanguage: 'en',
      layout: _getGoogleLayout(),
      autoDisplay: false
    };
    new google.translate.TranslateElement( gadgetOptions,  // jshint ignore:line
                                           GOOGLE_TRANSLATE_ELEMENT_ID );

    // Activate hooks to manipulate Google Website Translator Gadget through
    // the URL 'translate' parameter.
    _layout.activate();

    // Show the language links used to set the 'translate' parameter.
    _activateLanguageLinks();
  }

  // @return [Object] Return the inline Google Website Translator Gadget
  // layouts supplied by Google.
  function _getGoogleLayout() {
    if (_layoutType === VERTICAL)
      return google.translate.TranslateElement.InlineLayout.VERTICAL;
    else if (_layoutType === HORIZONTAL)
      return google.translate.TranslateElement.InlineLayout.HORIZONTAL;
  }

  // Overwrite/Create Google Website Translator Gadget cookies if the
  // 'translate' URL parameter is present.
  function _writeTranslateCookies() {
    var translateRequested = util.getParameterByName('translate');
    if (translateRequested) {
      var newCookieValue = '/en/'+translateRequested;
      var oldCookieValue = decodeURIComponent(cookie.read('googtrans'));
      if(newCookieValue !== oldCookieValue) {
        cookie.create('googtrans', newCookieValue, true);
        window.location.reload();
      }
    }
  }

  // Show any language links that appear on the page.
  function _activateLanguageLinks() {
    var links = document.querySelectorAll('.link-translate');
    var numLinks = links.length;
    while( numLinks > 0 ) {
      links[--numLinks].classList.remove('hide');
    }
  }

  return {
    init:init,
    isTranslated:isTranslated,
    InlineLayout:InlineLayout
  };
});
