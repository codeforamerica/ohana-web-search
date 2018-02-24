// manages geolocation
define(function () {
  'use strict';

  // Function to run on success or failure of locate() function.
  var _callBack;

  function locate(pCallBack) {
    _callBack = pCallBack;

    var geolocator = navigator.geolocation;
    if (geolocator) {
      var geoOptions = {
        maximumAge: 600000
      };
      // Request a position whose age is not greater than 10 minutes old.
      geolocator.getCurrentPosition(_success, _error, geoOptions);
    } else {
      var message = {
        message: 'Geolocation is not supported.'
      };
      _callBack.error(message);
    }
  }

  // Location successfully found.
  function _success(position) {
    _callBack.success(position);
  }

  // Error retrieving location.
  function _error(error) {
    switch(error.code) {
    case error.PERMISSION_DENIED:
      error.message = 'User denied the request for Geolocation.';
      break;
    case error.POSITION_UNAVAILABLE:
      error.message = 'Location information is unavailable.';
      break;
    case error.TIMEOUT:
      error.message = 'The request to get user location timed out.';
      break;
    case error.UNKNOWN_ERROR:
      error.message = 'An unknown error occurred.';
      break;
    }

    _callBack.error(error);
  }

  return {
    locate:locate
  };
});