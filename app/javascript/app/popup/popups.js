// Manages behavior of popups.
import DefaultPopup from 'app/popup/DefaultPopup';

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

export default {
  init:init
};
