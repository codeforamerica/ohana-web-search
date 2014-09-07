// Manages behavior of alert popups.
// The alert messages appear as a bar at the top of the screen when
// unexpected events occur, such as when geolocation could not determine
// the location of the user.
define(
function () {
  'use strict';

  // HTML element for the alert container.
  var _alertContainer;

  // HTML element for the alert box (inside the container).
  var _alert;

  // HTML element for the alert's content.
  var _content;

  // HTML element for the alert's close button.
  var _closeBtn;

  // 'Constants' for the types of alerts that can be displayed.
  var type = { VALID:1, ERROR:2, WARNING:4, INFO:8 };

  function init() {
    _alertContainer = document.querySelector('#alert-box');
    _alert = _alertContainer.querySelector('.alert');
    _content = _alertContainer.querySelector('.alert-message');
    _closeBtn = _alertContainer.querySelector('.alert-close');
    _closeBtn.addEventListener('click', _closeBtnClicked, false);

    // Set default type to an error alert.
    _alert.classList.add('alert-error');
  }

  // @param aType [Number] The type of alert.
  // May be type.VALID, type.ERROR, type.WARNING, or type.INFO.
  function setType(aType) {
    _alert.classList.remove('alert-valid');
    _alert.classList.remove('alert-error');
    _alert.classList.remove('alert-warning');
    _alert.classList.remove('alert-info');

    if (aType === type.VALID) _alert.classList.add('alert-valid');
    else if (aType === type.ERROR) _alert.classList.add('alert-error');
    else if (aType === type.WARNING) _alert.classList.add('alert-warning');
    else if (aType === type.INFO) _alert.classList.add('alert-info');
  }

  // @param message [String] Message to display in alert box.
  // @param aType [Number] The type of alert.
  // May be type.VALID, type.ERROR, type.WARNING, or type.INFO.
  function show(message, aType) {
    // Lazy initialization of alert.
    if (!_alertContainer) init();
    if (aType) setType(aType);
    _alertContainer.classList.remove('hide');
    _content.innerHTML = message;
  }

  // Hiding the alert box clears its content and hides it using CSS.
  function hide() {
    _alertContainer.classList.add('hide');
    _content.innerHTML = '';
  }

  // Closing the alert box hides the HTML.
  function _closeBtnClicked() {
    hide();
  }

  return {
    init:init,
    show:show,
    hide:hide,
    type:type
  };
});
