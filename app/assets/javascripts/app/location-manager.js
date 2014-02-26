// manages geolocation button on homepage
define(['util/geolocation','app/alert-manager','async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'], function (geo,alert) {
	'use strict';

		// PRIVATE PROPERTIES
		var _locateBtn; // locate current location button
		var _locationValue; // hidden field that contains location value


		// PUBLIC METHODS
		function init()
		{
			if (navigator.geolocation) // if geolocation is supported, show geolocate button
			{
				_locateBtn = document.getElementById('locate-btn');
				_locateBtn.addEventListener( "click" , _currLocationClicked , false );
				_locationValue = document.getElementById('location');
				_locateBtn.classList.remove('hide');
			}
		}

		// 'use current location' link clicked
		function _currLocationClicked(evt)
		{
			evt.preventDefault();
			_locateUser();
			return false;
		}

		// use geolocation to locate the user
		function _locateUser()
		{
			// callback object to hand off to geo locator object
			var callBack = {
				success:function(position)
				{
					var latitude = position.coords.latitude;
					var longitude = position.coords.longitude;
					_reverseGeocodeLocation(latitude,longitude);
				}
				,
				error:function(error)
				{
					//console.log("Geolocation failed due to: " + error.message);
					alert.show("Your location could not be determined!");
				}
			}

			geo.locate(callBack);
		}

		// reverse geocode the location based on lat/long and place in address field
		function _reverseGeocodeLocation(lat,lng)
		{
			var geocoder = new google.maps.Geocoder();
			var latlng = new google.maps.LatLng(lat,lng);

			geocoder.geocode({'latLng': latlng}, function(results, status)
			{
				if (status == google.maps.GeocoderStatus.OK && results[0])
			  {
					_locationValue.value = results[0].formatted_address;
					document.getElementById('location-form').submit();
			  }
			  else
			  {
					//console.log("Geocoder failed due to: " + status);
					alert.show("Your location could not be determined!");
			  }
			});
		}

	return {
		init:init
	};
});

