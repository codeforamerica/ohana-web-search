// handles search filter functionality
define(['util/geolocation/geolocate-action','domReady!'],
  function(geo) {
  'use strict';

  // PRIVATE PROPERTIES
  var _searchForm; // the form to submit

  // main module initialization
  function init()
  {
    // Set up geolocation button
    geo.init('locate-btn',_geolocationClicked);

    // capture form submission
    _searchForm = document.getElementById('search-form');

    // Hook reset button on the page and listen for a click event
    var resetBtn = document.getElementById('reset-btn');
    resetBtn.addEventListener('click',_resetClicked,false);
  }

  // The geolocation button was clicked in the location filter.
  function _geolocationClicked(address)
  {
    document.getElementById('location').value = address;
    _searchForm.submit();
  }

  // The clear filters button was clicked.
  function _resetClicked(evt)
  {
    document.getElementById('keyword').value = '';
    document.getElementById('location').value = '';
    document.getElementById('org_name').value = '';

    evt.preventDefault();
    evt.target.blur();
  }

  return {
    init:init,
  };
});