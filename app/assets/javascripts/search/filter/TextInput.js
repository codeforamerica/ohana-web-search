// Handles freeform text input search filters.
define(
function () {
  'use strict';

  function create(id) {
    return new TextInput(id);
  }

  function TextInput(id) {

    // The events this input broadcasts.
    var _events = {};

    // The container HTML element for this text input.
    var _container = document.querySelector('#' + id + ' .clearable');

    // The clear text button (x) HTML.
    var _buttonClear;

    // The actual text input to clear.
    var _input;

    // @param event [String] The event name to listen for. Supports 'change'.
    // @param callback [Function] The function called when the event has fired.
    function addEventListener(event, callback) {
      _events[event] = callback;
    }

    function reset() {
      _buttonClear.classList.add('hide');
      _input.value = '';
    }

    function _initClearButton() {
      // Retrieve first and only input element.
      // Throw an error if it isn't found.
      _input = _container.getElementsByTagName('input')[0];
      if (!_input) _throwInitializationError();

      // Create a clear button dynamically.
      _buttonClear = document.createElement('button');
      _buttonClear.className = 'button-clear';
      if (_input.value === '')
        _buttonClear.className += ' hide';
      _container.appendChild(_buttonClear);
      _buttonClear.addEventListener('click', function (evt) {
        evt.preventDefault();
        reset();
        _input.focus();
        _broadcastEvent('change');
      });

      _input.addEventListener('keyup', function (evt) {
        _setClearButtonVisibility();
      });

      _input.addEventListener('change', function (evt) {
        _setClearButtonVisibility();
        _broadcastEvent('change');
      });
    }

    // Hide the clear button if there isn't any input text,
    // otherwise show it.
    function _setClearButtonVisibility() {
      if (_input.value === '')
        _buttonClear.classList.add('hide');
      else
        _buttonClear.classList.remove('hide');
    }

    // @param evt [String] The type of event to broadcast.
    // Supports 'change'.
    function _broadcastEvent(evt) {
      if (_events[evt])
        _events[evt].call();
    }

    function _throwInitializationError() {
      var message = 'A clearable Text Input with id "' +
                    id + '" was not initialized!';
      throw new Error(message);
    }

    // Initialize TextInput instance.
    if (_container) _initClearButton();
    else _throwInitializationError();

    return {
      reset:reset,
      addEventListener:addEventListener
    };
  }

  return {
    create:create
  };
});
