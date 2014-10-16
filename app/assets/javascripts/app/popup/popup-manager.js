// Manages behavior of popups.
define([
  'app/popup/DefaultPopup',
  'app/popup/FeedbackPopup'
],
function (DefaultPopup, FeedbackPopup) {
  'use strict';

  // The last popup to be shown.
  var _lastPopup;

  function init() {
    var popupLinks = document.querySelectorAll('.popup-trigger');
    var numPopups = popupLinks.length;

    var popup;
    var link;
    while (numPopups > 0) {
      link = popupLinks[--numPopups];
      if (link.classList.contains('popup-feedback'))
        popup = FeedbackPopup.create(link);
      else
        popup = DefaultPopup.create(link);
      popup.addEventListener('show', _showPopupHandler);
    }
  }

  function _showPopupHandler(evt) {
    var popup = evt.target;
    if (_lastPopup && _lastPopup !== popup)
      _lastPopup.hide();
    _lastPopup = popup;
  }

  return {
    init:init
  };
});
