// Manages behavior of posting changes to the URL for
// inlinelayout.VERTICAL and inlinelayout.HORIZONTAL
// Google Website Translator Gadget layouts.
define([
  'util/util'
],
function (util) {
  'use strict';

  function create() {
    return new DropDownLayout();
  }

  function DropDownLayout() {

    // The HTML element that contain the language options.
    var _languages;

    // The ID of the Google Website Translator Gadget HTML container.
    var _googleTranslateElmID;

    function init(id) {
      _googleTranslateElmID = id;
    }

    function activate() {
      _languages = _getGoogleLayoutElement();
      _hookDropDown();
    }

    // @return [Object] The HTML element that contains the Google Translate
    // languages.
    function _getGoogleLayoutElement() {
      var query = '#'+_googleTranslateElmID + ' select';
      var elm = document.querySelector(query);
      if (!elm)
        throw new Error('Google Website Translator Gadget HTML not found!');
      return elm;
    }

    // Hook in a change event to the language drop-down menu so the page reloads
    // and is appended a translate query string when the drop-down menu changes.
    function _hookDropDown() {
      _languages.addEventListener('change', _languageDropDownChanged, false);
    }

    // Update the URL with the selected language.
    function _languageDropDownChanged() {
      var options = {
        'translate': _languages.options[_languages.selectedIndex].value
      };
      document.location.search = util.queryString(options);
    }

    return {
      init:init,
      activate:activate
    };
  }

  return {
    create:create
  };
});
