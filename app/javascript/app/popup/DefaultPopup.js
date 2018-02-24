// Used for creating a popup that appears when the designated link is clicked.
define([
  'util/util',
  'util/EventObserver'
],
function (util, eventObserver) {
  'use strict';

  // Create a DefaultPopup instance.
  // @return [Object] The DefaultPopup instance.
  function create() {
    return new DefaultPopup();
  }

  function DefaultPopup() {
    var _instance = this;

    // The events this instance broadcasts.
    var _events = {
      SHOW: 'show',
      HIDE: 'hide'
    };

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

    // Initialize the popup.
    // @param link [String] An HTML anchor element
    //   that contains the Popup ID as a hash.
    // @param instance [Object] Optional reference to an instance.
    //   If this DefaultPopup is extended by another popup the instance should
    //   point to that descendant popup instead of this instance.
    // @return [Object] The DefaultPopup instance,
    //   or the instance passed into the init method.
    function init(link, instance) {

      if (instance) _instance = instance;
      eventObserver.attach(_instance);

      _link = link;
      _popup = document.querySelector(_link.hash);
      if (!_link || !_popup) {
        var message = 'Popup has not been properly initialized! ' +
                      'Check HTML id and ensure init method has been called.';
        throw new Error(message);
      }

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

      _instance.show = show;
      _instance.hide = hide;
      _instance.toggle = toggle;
      return _instance;
    }

    // Show the popup.
    // @return [Object] The DefaultPopup instance.
    function toggle() {
      if (_isShowing()) hide();
      else show();
      return _instance;
    }

    // Show the popup.
    // @return [Object] The DefaultPopup instance.
    function show() {
      _render();
      window.addEventListener('resize', _resizeHandler, true);
      _instance.dispatchEvent(_events.SHOW, {target:_instance});
      return _instance;
    }

    // Hide the popup.
    // @return [Object] The DefaultPopup instance.
    function hide() {
      if (_isShowing()) {
        _container.classList.add('hide');
        window.removeEventListener('resize', _resizeHandler, true);
        _instance.dispatchEvent(_events.HIDE, {target:_instance});
      }
      return _instance;
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
    function _closeClickedHandler() {
      hide();
    }

    _instance.init = init;
    return _instance;
  }

  return {
    create:create
  };
});
