// Manages behavior of popups.
define([
  'app/popup/DefaultPopup',
  'app/popup/FeedbackPopup'
],
function (DefaultPopup, FeedbackPopup) {
  'use strict';

  // Store the last popup shown so that it can be hidden when
  // a new popup is shown.
  var _lastPopup;

  function init() {
    var popupLinks = document.querySelectorAll('.popup-trigger');
    var numPopups = popupLinks.length;

    var popup;
    var link;
    while (numPopups > 0) {
      link = popupLinks[--numPopups];
      if (link.classList.contains('popup-feedback'))
        popup = FeedbackPopup.create().init(link);
      else
        popup = DefaultPopup.create().init(link);
      popup.addEventListener('show', _showPopupHandler);
    }
  }

  // Hide the last popup shown.
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
