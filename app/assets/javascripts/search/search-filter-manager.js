// Handles search filter functionality.
define([
  'search/filter/TextInput',
  'search/filter/CheckboxSubtractive',
  'util/geolocation/geolocate-action',
  'app/alert-manager',
  'domReady!'
],
function (TextInput, CheckboxSubtractive, geo, alert) {
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

    // Set up checkbox filters
    var kind = CheckboxSubtractive.create('kind-options');
    kind.addEventListener('change', _showNotice);

    var serviceArea = CheckboxSubtractive.create('service-area-options');
    serviceArea.addEventListener('change', _showNotice);

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

  function _showNotice() {
    var notice = "<a id='update-results' style='cursor:pointer;'>" +
                 "<i class='fa fa-refresh'></i> Update search results!" +
                 '</a>';
    alert.show(notice, alert.type.INFO);
    var trigger = document.getElementById('update-results');
    trigger.onclick = function(){ _searchForm.submit(); };
  }

  return {
    init:init
  };
});
