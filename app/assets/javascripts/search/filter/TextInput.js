// Handles freeform text input search filters.
define(
function () {
  'use strict';

  function create(id) {
    return new TextInput(id);
  }

  function TextInput(id) {

    // @param event [String] The event name to listen for. Supports 'change'.
    // @param callback [Function] The function called when the event has fired.
    function addEventListener(event, callback) {
      _events[event] = callback;
    }

    function reset() {
      var closeButton = _container.querySelector('.button-close');
      closeButton.classList.add('hide');
    }

    function _initCloseButton() {
      // Retrieve first and only input element.
      var input = _container.getElementsByTagName('input')[0];

      // Create a clear button dynamically.
      var buttonClear = document.createElement('button');
      buttonClear.className = 'button-close';
      if (input.value === '')
        buttonClear.className += ' hide';
      _container.appendChild(buttonClear);

      buttonClear.addEventListener('click', function (evt) {
        evt.preventDefault();
        input.value = '';
        buttonClear.classList.add('hide');
        input.focus();
        _events.change.call();
      });

      input.addEventListener('keyup', function (evt) {
        _checkClearButtonVisibility(input, buttonClear);
      });

      input.addEventListener('change', function (evt) {
        _checkClearButtonVisibility(input, buttonClear);
        _events.change.call();
      });
    }

    // @param input [Object] The input field where a search is entered.
    // @param buttonClear [Object] The clear button for clearing the form.
    function _checkClearButtonVisibility(input, buttonClear) {
      if (input.value === '')
        buttonClear.classList.add('hide');
      else
        buttonClear.classList.remove('hide');
    }

    // Initialize TextInput instance.
    var _events = {};
    var _container = document.querySelector('#' + id + ' .clearable');
    if (_container) _initCloseButton();

    return {
      reset:reset,
      addEventListener:addEventListener
    };
  }

  return {
    create:create
  };
});
