// Handles freeform text input search filters.
define([
  'util/EventObserver'
],
function (eventObserver) {
  'use strict';

  function create(id) {
    return new TextInput(id);
  }

  function TextInput(id) {
    var _instance = this;

    // The events this instance broadcasts.
    var _events = { CHANGE: 'change' };
    eventObserver.attach(this);

    // The container HTML element for this text input.
    var _container = document.querySelector('#' + id + ' .clearable');

    // The clear text button (x) HTML.
    var _buttonClear;

    // The actual text input to clear.
    var _input;

    function reset() {
      _buttonClear.classList.add('hide');
      _input.value = '';
    }

    function _initClearButton() {
      // Retrieve first and only input element.
      // Throw an error if it isn't found.
      if (!_container) _throwInitializationError();
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
        _instance.dispatchEvent(_events.CHANGE, {target:_instance});
      });

      _input.addEventListener('keyup', function () {
        _setClearButtonVisibility();
      });

      _input.addEventListener('change', function () {
        _setClearButtonVisibility();
        _instance.dispatchEvent(_events.CHANGE, {target:_instance});
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

    function _throwInitializationError() {
      var message = 'A clearable Text Input with id "' +
                    id + '" was not initialized!';
      throw new Error(message);
    }

    // Initialize TextInput instance.
    _initClearButton();

    _instance.reset = reset;

    return _instance;
  }

  return {
    create:create
  };
});
