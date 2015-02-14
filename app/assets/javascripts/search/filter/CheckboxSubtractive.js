// Handles checkbox filters that subtractively refine the search results.
define(
function () {
  'use strict';

  function create(id) {
    return new CheckboxSubtractive(id);
  }

  function CheckboxSubtractive(id) {

    // The events this input broadcasts.
    var _events = {};

    // The container HTML element for this group of checkbox inputs.
    var _container = document.querySelector('#' + id + ' .toggle-container');

    // The checkbox input HTML.
    var _toggles = document.querySelectorAll('#' + id + ' .toggle input');

    function _checkToggles() {
      var len, toggle, isChecked;
      if (!_toggles) _throwInitializationError();
      len = _toggles.length-1;
      while( len >= 0 ) {
        toggle = _toggles[len--];
        toggle.addEventListener('click', _checkToggle, false);
        if (toggle.checked) isChecked = true;
      }

      if (isChecked) _active();
      else _deactive();
    }

    function _checkToggle() {
      _checkToggles();
      _broadcastEvent('change');
    }

    // Darken text when active.
    function _active() {
      _container.classList.add('active');
    }

    // Darken text when deactive.
    function _deactive() {
      _container.classList.remove('active');
    }

    function addEventListener(event, callback) {
      _events[event] = callback;
    }

    // @param evt [String] The type of event to broadcast.
    // Supports 'change'.
    function _broadcastEvent(evt) {
      if (_events[evt])
        _events[evt].call();
    }

    function _throwInitializationError() {
      var message = 'A Checkbox Input with id "' +
                    id + '" was not initialized!';
      throw new Error(message);
    }

    // Initialize CheckboxSubtractive instance.
    if (_container) _checkToggles();
    else _throwInitializationError();

    return {
      addEventListener:addEventListener
    };

  }

  return {
    create:create
  };
});
