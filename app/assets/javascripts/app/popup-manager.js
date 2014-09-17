// Manages behavior of popups.
define([
  'util/translation/google-translate-manager',
  'util/util',
  'app/feedback-form-manager'
],
function (googleTranslate, util, feedback) {
  'use strict';

  // List of popups on the page.
  var _popups;

  // The last popup to be shown.
  var _lastPopup;
  var _lastTrigger;

  // Padding set on article > div.
  var PADDING = 20;

  function init() {
    _addPopups();
    feedback.init();
  }

  // Adds hooks for triggering popups present on the page.
  function _addPopups() {
    _popups = document.querySelectorAll('.popup-trigger');

    var curr;
    for (var p = 0, len = _popups.length; p < len; p++)
    {
      curr = _popups[p];
      curr.addEventListener('click', _popupHandler, false);
      curr.classList.add('active');
    }
  }

  // Removes popups and hooks.
  /* Upcomment the following to provide a method to remove the popups.
  function _removePopups() {
    _closeLastPopup();
    _lastPopup = null;
    _lastTrigger = null;
    _popups = document.querySelectorAll('.popup-trigger');

    var curr;
    for (var p = 0, len = _popups.length; p < len; p++) {
      curr = _popups[p];
      curr.removeEventListener('click', _popupHandler, false);
      curr.classList.remove('active');
    }
  }
  */

  // Handler for when a popup link triggers a popup.
  function _popupHandler(evt) {
    evt.preventDefault();

    var trigger = evt.target;
    var thisPopup = document.querySelector(trigger.hash);

    _show(thisPopup,trigger);
    window.addEventListener('resize', _resizeHandler, true);

    return false;
  }

  // Handler for when the page is resized.
  function _resizeHandler() {
    _show(_lastPopup, _lastTrigger);
  }

  // Show a popup.
  // @param popup Reference to the popup HTML to show.
  // @param trigger Reference to the link trigger HTML.
  function _show(popup, trigger) {
    if (!googleTranslate.isTranslated()) {
      _lastTrigger = trigger;

      var container = popup.parentNode;
      var arrow = container.children[0];

      // Get the window dimensions.
      var winDim = util.getWindowRect();

      // Find the position offset values of the link that triggered the popup.
      var offset = util.getOffset(trigger);
      var offsetY = offset.top+trigger.offsetHeight;
      var offsetX = offset.left;

      // Offset needed for CSS adjustments of rotating arrow.
      // To move popup up/down, adjust the arrowOffset.top value, which will
      // cascade down to the popupOffset.
      var arrowOffset = { 'top': -6, 'left': -14 };
      var popupOffset = { 'top': 15 + arrowOffset.top };

      // Position the arrow relative to the triggering link.
      arrow.style.top = (offsetY + arrowOffset.top) + 'px';
      arrow.style.left = (offsetX +
                          arrowOffset.left +
                          (trigger.offsetWidth/2)) + 'px';

      // Position the popup relative to the window.
      popup.style.top = (offsetY + popupOffset.top) + 'px';

      var cssWidth = util.getStyle(popup, 'width');
      var offsetWidth = offsetX +
                        Number(cssWidth.substring(0, cssWidth.length - 2));

      if (offsetWidth > winDim.width) {
        popup.style.right = '10px';
      } else {
        popup.style.left = offsetX + 'px';
      }

      if (_lastPopup && _lastPopup !== popup)
        _lastPopup.parentNode.classList.add('hide');
      _lastPopup = popup;
      _lastPopup.parentNode.classList.toggle('hide');

      // Set height to default in order to check against window height.
      popup.style.height = 'auto';

      var padding = PADDING;
      if ( (offsetY + popup.offsetHeight + padding) > winDim.height) {
        popup.style.height = (winDim.height - offsetY - padding) + 'px';
      } else {
        popup.style.height = 'auto';
      }

      popup.style.zIndex = '9999';
      arrow.style.zIndex = '10000';

      // Attach to content element, as document directly doesn't work correctly
      // on Mobile Safari.
      var content = document.getElementById('content');
      content.addEventListener('mousedown', _closeHandler, true);
    }
  }

  // Handler for closing the popup.
  function _closeHandler(evt) {
    var el = evt.target;
    if (el.classList.contains('close-button'))
      _closeLastPopup();
  }

  // Close the last opened popup.
  function _closeLastPopup() {
    if (_lastPopup)
      _lastPopup.parentNode.classList.add('hide');
    var content = document.getElementById('content');
    content.removeEventListener('mousedown', _closeHandler, true);
    window.removeEventListener('resize', _resizeHandler, true);
    feedback.hide();
  }

  return {
    init:init
  };
});
