// manages results maps view
define(['util/util'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _mapContainer;
		var _map;

		// PUBLIC METHODS
		function init()
		{
			var title = document.getElementById("detail-map-canvas-title");
			var lat = document.getElementById("detail-map-canvas-lat");
			var lng = document.getElementById("detail-map-canvas-lng");

			if (title && lat && lng)
			{
				title = title.innerHTML;
				lat = lat.innerHTML;
				lng = lng.innerHTML;

			  var latlng = new google.maps.LatLng(lat,lng);

			  var mapOptions = {
			    zoom: 16,
			    center: latlng,
			    zoomControl: true,
			    panControl: false,
			    streetViewControl: false,
			    scaleControl: true,
			    scaleControlOptions: {
	        position: google.maps.ControlPosition.RIGHT_BOTTOM
	    	},

			    mapTypeControl: false,
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			  }
			  _map = new google.maps.Map(document.getElementById("detail-map-canvas"), mapOptions);

			  
			  var locationMarker = new google.maps.Marker({
						map: _map,
						title: title,
						position: latlng
					});

			}
		}

	return {
		init:init
	};
});
