// Used for creating a popup that appears when the designated link is clicked.
define([
  'util/util'
],
function (util) {
  'use strict';

  // Create a DefaultPopup instance.
  // @return [Object] The DefaultPopup instance.
  function create(link) {
    return new DefaultPopup().init(link);
  }

  function DefaultPopup() {

    // The events this instance broadcasts.
    var _events = {};

    // The trigger link to show/hide the popup.
    var _link;

    // The popup DOM element. ID is stored as a hash in the trigger link.
    var _popup;

    // The container DOM element for the popup.
    var _container;

    // The DOM element for the popup's arrow that points to the trigger link.
    var _arrow;

    // The DOM element for the close button (x).
    var _closeButton;

    // The calculated width of the popup.
    var _popupWidth;

    // Padding set on article > div inside the popup.
    var _popupPadding;

    var instance = this;

    // Initialize the popup.
    // @return [Object] The DefaultPopup instance.
    function init(link) {
      _link = link;
      _popup = document.querySelector(_link.hash);

      if (!_link || !_popup) _throwInitializationError();

      _container = _popup.parentNode;
      _arrow = _container.children[0];
      _closeButton = _popup.querySelector('.close-button');

      _link.classList.add('active');
      _link.addEventListener('click', _linkClickHandler, false);

      _closeButton.addEventListener('mousedown', _closeClickedHandler, false);

      _popup.style.zIndex = '9999';
      _arrow.style.zIndex = '10000';

      var padding = util.getStyle(_popup.children[1], 'padding');
      _popupPadding = parseInt(padding, 10);
      _updatePopupContentWidth();

      return instance;
    }

    // Show the popup.
    // @return [Object] The DefaultPopup instance.
    function toggle() {
      if (_isShowing()) hide();
      else show();
      return instance;
    }

    // Show the popup.
    // @return [Object] The DefaultPopup instance.
    function show() {
      _render();
      window.addEventListener('resize', _resizeHandler, true);
      _broadcastEvent('show', {target:instance});
      return instance;
    }

    // Hide the popup.
    // @return [Object] The DefaultPopup instance.
    function hide() {
      if (_isShowing()) {
        _container.classList.add('hide');
        window.removeEventListener('resize', _resizeHandler, true);
        _broadcastEvent('hide', {target:instance});
      }
      return instance;
    }

    // @param event [String] The event name to listen for.
    //   Supports 'show' and 'hide'.
    // @param callback [Function] The function called when the event has fired.
    // @return [Object] The DefaultPopup instance.
    function addEventListener(event, callback) {
      _events[event] = callback;
      return instance;
    }

    // @param evt [String] The type of event to broadcast.
    //   Supports 'show' and 'hide'.
    // @param options [Object] The event object to pass to the event handler.
    function _broadcastEvent(evt, options) {
      options = options || {};
      if (_events[evt])
        _events[evt].call(_events[evt], options);
    }

    function _linkClickHandler(evt) {
      evt.preventDefault();
      toggle();
    }

    function _updatePopupContentWidth() {
      _popupWidth = parseInt(util.getStyle(_popup, 'width'), 10);
    }

    // @return [Boolean] True if the popup is showing, false otherwise.
    function _isShowing() {
      return !_container.classList.contains('hide');
    }

    function _render() {
      // Get the window dimensions.
      var winDim = util.getWindowRect();

      // Find the position offset values of the link that triggered the popup.
      var offset = util.getOffset(_link);
      var offsetY = offset.top + _link.offsetHeight;
      var offsetX = offset.left;

      // Offset needed for CSS adjustments of rotated arrow.
      // To move popup up/down, adjust the arrowOffset.top value, which will
      // cascade down to the popupOffset.
      var arrowOffset = { 'top': -6, 'left': -14 };
      var popupOffset = { 'top': 15 + arrowOffset.top };

      // Position the arrow relative to the triggering link.
      _arrow.style.top = (offsetY + arrowOffset.top) + 'px';
      _arrow.style.left = (offsetX + arrowOffset.left +
                          (_link.offsetWidth/2)) + 'px';

      // Position the popup relative to the window.
      _popup.style.top = (offsetY + popupOffset.top) + 'px';

      //var cssWidth = util.getStyle(_popup, 'width');
      var offsetWidth = offsetX + _popupWidth;

      _popup.style.right = 'auto';
      _popup.style.left = 'auto';
      if (offsetWidth > winDim.width) {
        _popup.style.right = '10px';
      } else {
        _popup.style.left = offsetX + 'px';
      }

      // Actually show the popup.
      _container.classList.remove('hide');

      // After showing popup, check that it isn't higher than available area.
      // Set height to default in order to check against window height.
      _popup.style.height = 'auto';
      if ( (offsetY + _popup.offsetHeight + _popupPadding) > winDim.height) {
        _popup.style.height = (winDim.height - offsetY - _popupPadding) + 'px';
        _updatePopupContentWidth();
      }
    }

    // Handler for when the page is resized.
    function _resizeHandler() {
      _render();
    }

    // Handler for closing the popup.
    function _closeClickedHandler(evt) {
      hide();
    }

    function _throwInitializationError() {
      var message = 'A popup with id "' + _link.hash +
                    '" was not initialized!';
      throw new Error(message);
    }

    instance.init = init;
    instance.show = show;
    instance.hide = hide;
    instance.toggle = toggle;
    instance.addEventListener = addEventListener;

    return instance;
  }

  return {
    create:create
  };
});