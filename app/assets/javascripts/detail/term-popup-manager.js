// Manages behavior of terminology popups.
define(function() {
  'use strict';

  // PRIVATE PROPERTIES
  var _lastPopup; // the last popup to be shown
  var _contentElm;

  // PUBLIC METHODS
  function init() {

    // DOM reference to main content area of page.
    _contentElm = document.getElementById('content');

    // Array of popups on the page.
    var popups = document.querySelectorAll( '.term-popup-container' );

    var popup, term;
    for ( var p = 0, len = popups.length; p < len; p++ ) {
      popup = popups[p].firstElementChild;
      term = popups[p].lastElementChild;
      if ((/\S/.test(popup.textContent))) {
        term.addEventListener('mousedown', _popupHandler, false);
        term.classList.add('active');
      }
    }
  }

  // PRIVATE METHODS
  function _popupHandler(evt) {
    var thisPopup = (evt.target).parentElement.firstElementChild;
    if (_lastPopup && _lastPopup !== thisPopup) {
      _lastPopup.classList.add('hide');
    }
    _lastPopup = thisPopup;
    _lastPopup.classList.toggle('hide');
    _lastPopup.style.top = (_lastPopup.offsetHeight * -1) + 'px';
    _contentElm.addEventListener('mousedown', _closeHandler, true);
  }

  function _closeHandler(evt) {
    var popup = evt.target;
    if (popup.attributes.href !== undefined &&
      !popup.classList.contains('popup-term')) {
      return;
    }
    _lastPopup.classList.add('hide');
    document.removeEventListener('mousedown', _closeHandler, true);
    _contentElm.removeEventListener('mousedown', _closeHandler, true);
  }

  return {
    init:init
  };
});