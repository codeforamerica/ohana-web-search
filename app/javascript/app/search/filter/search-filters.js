// Handles search filter functionality.
define([
  'search/filter/TextInput',
  'util/geolocation/geolocate-action',
  'domReady!'
],
function (TextInput, geo) {
  'use strict';

  // The search filters.
  var _keyword;
  var _location;
  var _agency;

  // The form to submit.
  var _searchForm;

  // Main module initialization.
  function init() {

    // Set up geolocation button.
    geo.init('button-geolocate', _geolocationClicked);

    // Set up text input filters
    _keyword = TextInput.create('keyword-search-box');
    _location = TextInput.create('location-options');
    _agency = TextInput.create('org-name-options');

    // Capture form submission.
    _searchForm = document.getElementById('form-search');

    // Hook reset button on the page and listen for a click event.
    var resetButton = document.getElementById('button-reset');
    resetButton.addEventListener('click', _resetClicked, false);
  }

  // The geolocation button was clicked in the location filter.
  function _geolocationClicked(address) {
    document.getElementById('location').value = address;
    _searchForm.submit();
  }

  // The clear filters button was clicked.
  function _resetClicked(evt) {
    _keyword.reset();
    _location.reset();
    _agency.reset();

    evt.preventDefault();
    evt.target.blur();
  }

  return {
    init:init
  };
});
