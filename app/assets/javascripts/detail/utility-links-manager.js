// Manages the utility links that appear on the details view.
define(
function () {
  'use strict';

  // The DOM element for the print button utility link.
  var _printButton;

  function init() {
    _printButton = document.querySelector('.utility-links .button-print');

    // Set event on print button and show the button.
    _printButton.addEventListener('click', _clickPrintButton, false);
    _printButton.classList.remove('hide');
  }

  // Issue print command when print button is clicked.
  // @param evt [Object] The click event object.
  function _clickPrintButton(evt) {
    evt.preventDefault();
    window.print();
  }

  return {
    init:init
  };
});
