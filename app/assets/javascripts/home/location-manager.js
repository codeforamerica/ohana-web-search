// manages results maps view
define(['util/geolocation','async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'], function (geo) {
	'use strict';

		// PRIVATE PROPERTIES
		var _showLocationBtn; // services near me button
		var _locationSearchBtn; // search location button
		var _locationBox; // popup box for location search
		var _locationInput; // location input text field
		var _locateBtn; // locate current location button


		// PUBLIC METHODS
		function init(callback)
		{
			_showLocationBtn = document.getElementById('location-btn');
			_locationSearchBtn = document.getElementById('location-search-btn');
			_locationBox = document.getElementById('location-box');
			_locationInput = document.getElementById('location');

			_locateBtn = document.getElementById('locate-btn');
			_locateBtn.addEventListener( "click" , _currLocationClicked , false );

			_showLocationBtn.addEventListener('click', _showLocationBtnClicked, false);

			var closeBtn = document.getElementById('locate-close-btn'); // hackish way to find the close button, but it's fast
			closeBtn.addEventListener('click',_closeBtnClicked,false);
		}

		function _closeBtnClicked(evt)
		{
			_locationBox.classList.add('hide');
			if (_locationInput.value)
				_dispatchSubmitBtn();
		}

		function _showLocationBtnClicked(evt)
		{
			evt.preventDefault();
			_locationBox.classList.remove('hide');
			return false;
		}

		function _dispatchSubmitBtn()
		{
			if(document.createEvent)
			{
			    var click = document.createEvent("MouseEvents");
			    click.initMouseEvent("click", true, true, window,
			    0, 0, 0, 0, 0, false, false, false, false, 0, null);
			    _locationSearchBtn.dispatchEvent(click);
			    _locationSearchBtn.focus();
			}
			else if(document.documentElement.fireEvent)
			{
			    _locationSearchBtn.fireEvent("onclick");
			    _locationSearchBtn.focus();
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
					console.log("Geolocation failed due to: " + error.message);
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
					_locationInput.value = results[0].formatted_address;
					_dispatchSubmitBtn();
			  }
			  else
			  {
					console.log("Geocoder failed due to: " + status);
			  }
			});
		}

	return {
		init:init
	};
});
