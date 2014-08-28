// Handles checkbox filters that subtractively refine the search results.
define(
function () {
  'use strict';

  function create(id) {
    return new CheckboxSubtractive(id);
  }

  function CheckboxSubtractive(id) {

    var _events = {};

    var _container = document.querySelector('#' + id + ' .toggle-container');
    var _toggles = document.querySelectorAll('#' + id + ' .toggle input');

    _checkToggles();

    function _checkToggles() {
      var len, toggle, isChecked;
      len = _toggles.length-1;
      while( len >= 0 ) {
        toggle = _toggles[len--];
        toggle.addEventListener('click', _checkToggle, false);
        if (toggle.checked) isChecked = true;
      }

      if (isChecked) _active();
      else _deactive();
    }

    function _checkToggle(evt) {
      _checkToggles();
      var callback = _events['change'];
      if (callback) callback.call();
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

    return {
      addEventListener:addEventListener
    }

  }

  return {
    create:create
  };
});
