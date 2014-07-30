// Handles search filter functionality.
define([
  'util/geolocation/geolocate-action',
  'domReady!'
],
function (geo) {
  'use strict';

  // The form to submit.
  var _searchForm;

  // Main module initialization.
  function init() {
    // Set up geolocation button.
    geo.init('button-geolocate', _geolocationClicked);

    // Capture form submission.
    _searchForm = document.getElementById('form-search');

    // Hook reset button on the page and listen for a click event.
    var resetButton = document.getElementById('button-reset');
    resetButton.addEventListener('click', _resetClicked,false);
  }

  // The geolocation button was clicked in the location filter.
  function _geolocationClicked(address) {
    document.getElementById('location').value = address;
    _searchForm.submit();
  }

  // The clear filters button was clicked.
  function _resetClicked(evt) {
    document.getElementById('keyword').value = '';
    document.getElementById('location').value = '';
    document.getElementById('org_name').value = '';

    evt.preventDefault();
    evt.target.blur();
  }

  return {
    init:init
  };
});
