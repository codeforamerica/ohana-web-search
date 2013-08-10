// manages results maps view
define(['util/util','async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _map;
		var _cover; // cover for map

		// PUBLIC METHODS
		function init()
		{
			_cover = document.getElementById("detail-map-cover");
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

				_cover.addEventListener('click',_mapCoverClicked,false);
				google.maps.event.addListener(_map,'mouseout',_mapCoverOut);
				_cover.classList.remove('hide');
			}
		}

		function _mapCoverClicked(evt)
		{
			_cover.classList.add('hide');
		}

		function _mapCoverOut(evt)
		{
			_cover.classList.remove('hide');
		}

	return {
		init:init
	};
});
