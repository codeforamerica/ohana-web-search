// Manages geolocation action, which can be associated with a button.
define([
  'util/geolocation/geolocator',
  'app/alerts',
  'util/map/google/map-loader',
  'domReady!'
],
function (geo, alerts, googleMaps) {
  'use strict';


  // Locate current geolocation button.
  var _locateTarget;

  // The text in the geolocation button.
  var _locateTargetTextContainer;

  // A callback function for when the location is determined.
  var _locateAction;

  // 'Constant' used in error alert message.
  var LOCATION_NOT_FOUND_ERROR_TEXT = 'Your location could not be determined!';

  function init(target, locateAction) {
    // If geolocation is supported, show geolocate button.
    if (navigator.geolocation) {
      _locateTarget = document.getElementById(target);
      _locateTarget.classList.remove('hide');
      _locateTargetTextContainer = _locateTarget.querySelector('span');
      _locateAction = locateAction;

      _locateTarget.addEventListener('click', _currLocationAction, false);
    }
  }

  // Target element was clicked.
  function _currLocationAction(evt) {
    evt.preventDefault();
    _locateTargetBusy();
    _locateUser();
  }

  // Use geolocation to locate the user.
  function _locateUser() {
    // Callback object to hand off to geo locator object.
    var callBack = {
      success: function(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;

        googleMaps.load(function() {
          _reverseGeocodeLocation(latitude, longitude);
        });
      },
      error: function(error) { // jshint ignore:line
        //console.log("Geolocation failed due to: " + error.message);
        alerts.show(LOCATION_NOT_FOUND_ERROR_TEXT, alerts.type.ERROR);
        _locateTargetReady();
      }
    };

    geo.locate(callBack);
  }

  // Reverse geocode the location based on lat/long and place in address field.
  function _reverseGeocodeLocation(lat, lng) {
    var geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(lat, lng);

    geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status === google.maps.GeocoderStatus.OK && results[0]) {
        _locateAction(results[0].formatted_address);
      } else {
        //console.log("Geocoder failed due to: " + status);
        alerts.show(LOCATION_NOT_FOUND_ERROR_TEXT, alerts.type.ERROR);
        _locateTargetReady();
      }
    });
  }

  // Set content of button to busy state.
  function _locateTargetBusy() {
    var waitText = _locateTarget.getAttribute('data-wait-text');
    _locateTargetTextContainer.innerHTML = waitText;
    _locateTarget.setAttribute('disabled', 'disabled');
  }

  // Set content of button to ready state.
  function _locateTargetReady() {
    var regularText = _locateTarget.getAttribute('data-regular-text');
    _locateTargetTextContainer.innerHTML = regularText;
    _locateTarget.removeAttribute('disabled');
  }

  return {
    init:init
  };
});

