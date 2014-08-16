// Handles functionality of search inputs, such as how the inputs are cleared.
define(
function () {
  'use strict';

  // A list of elements with the clearable class.
  var _inputs;

  function init() {
    // Find all elements with the clearable class.
    _inputs = document.querySelectorAll('.clearable');

    for (var i = 0, len = _inputs.length; i < len; i++) {
      _initCloseButton(_inputs[i])
    }

    // Find the global reset button so all search inputs can be cleared.
    var buttonReset = document.getElementById('button-reset');
    buttonReset.addEventListener('click', _resetClicked);
  }

  function _resetClicked(evt) {
    var closeButton;
    for (var i = 0, len = _inputs.length; i < len; i++) {
      closeButton = _inputs[i].querySelector('.button-close');
      closeButton.classList.add('hide');
    }
  }

  // @param inputContainer [Object] The container element enclosing an
  // input field and close button.
  function _initCloseButton(inputContainer) {

    // Retrieve first and only input element.
    var input = inputContainer.getElementsByTagName('input')[0];

    // Create a clear button dynamically.
    var buttonClear = document.createElement('button');
    buttonClear.className = 'button-close';
    if (input.value === '')
      buttonClear.className += ' hide';
    inputContainer.appendChild(buttonClear);

    buttonClear.addEventListener('click', function (evt) {
      evt.preventDefault();
      input.value = '';
      buttonClear.classList.add('hide');
      input.focus();
    })

    input.addEventListener('keyup', function (evt) {
      _checkClearButtonVisibility(input, buttonClear);
    })

    input.addEventListener('change', function (evt) {
      _checkClearButtonVisibility(input, buttonClear);
    })
  }

  // @param input [Object] The input field where a search is entered.
  // @param buttonClear [Object] The clear button for clearing the form.
  function _checkClearButtonVisibility(input, buttonClear) {
    if (input.value === '')
        buttonClear.classList.add('hide');
    else
      buttonClear.classList.remove('hide');
  }

  return {
    init:init
  };
});
