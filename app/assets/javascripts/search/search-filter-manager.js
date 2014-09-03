// Handles search filter functionality.
define([
  'search/filter/TextInput',
  'util/geolocation/geolocate-action',
  'app/alert-manager',
  'domReady!'
],
function (TextInput, geo, alert) {
  'use strict';

  // The form to submit.
  var _searchForm;

  // Main module initialization.
  function init() {

    // Set up geolocation button.
    geo.init('button-geolocate', _geolocationClicked);

    // Set up text input filters
    var keyword = TextInput.create('keyword-search-box');
    var location = TextInput.create('location-options');
    var agency = TextInput.create('org-name-options');

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
    keyword.reset();
    location.reset();
    agency.reset();

    evt.preventDefault();
    evt.target.blur();
  }

  return {
    init:init
  };
});
