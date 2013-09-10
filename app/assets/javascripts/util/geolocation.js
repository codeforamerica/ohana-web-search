// manages geolocation
define(function() {
  'use strict';

	// function to run on success or failure, new instance should be passed into geo.locate()
	var _callBack;

	function locate(pCallBack)
	{
		_callBack = pCallBack;

		// modernizr should pick this up, but just in case...
		if (navigator.geolocation)
		{
			// Request a position whose age is not greater than 10 minutes old.
			navigator.geolocation.getCurrentPosition(_success,_error,{maximumAge:600000});
		}
		else{
			_callBack.error({message:"Geolocation is not supported."});
		}
	}

	// location successfully found
	function _success(position)
	{
		_callBack.success(position);
	}

	// error retrieving location
	function _error(error)
	{
		switch(error.code)
		{
			case error.PERMISSION_DENIED:
				 error.message = "User denied the request for Geolocation.";
			break;
			case error.POSITION_UNAVAILABLE:
				error.message = "Location information is unavailable.";
			break;
			case error.TIMEOUT:
				error.message = "The request to get user location timed out.";
			break;
			case error.UNKNOWN_ERROR:
				error.message = "An unknown error occurred.";
			break;
		}

		_callBack.error(error);
	}

	return {
		locate:locate
	};
});