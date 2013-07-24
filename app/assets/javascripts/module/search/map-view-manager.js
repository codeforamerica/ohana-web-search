// manages results maps view
define(['util/util'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _mapContainer;
		var _map;
		var _markerData; // markers on the map
		var _markersArray = []; // array for storing markers
		var _markerBounds;
		var _markerInfo; // info window that shows when markers are rolled over
		var _callback; // callback function for passing updates

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;
			_mapContainer = document.getElementById("map-view");

		  var mapOptions = {
		    zoom: 4,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		  }
		  _map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		  _markerInfo = document.getElementById("marker-info");

		  google.maps.event.addListener(_map,"tilesloaded",_mapLoaded);
		  refresh();
		}

		// register events on the map
		function _mapLoaded(evt)
		{
			google.maps.event.addListener(_map,"zoom_changed",_mapZoomed);
		}

		function _mapZoomed(evt)
		{
			_updateRadius(map.getRadius());
		}

		function _updateRadius(val)
		{
			_radius = val;
			_callback();
		}

		// loads marker data
		function _loadData()
		{
			var locations = document.getElementById("map-locations");
			if (locations)
		    _markerData = JSON.parse(locations.innerHTML);
		  else
		  	_hideMap();
		}

		// hide the map if there's no data to populate it
		function _hideMap()
		{
			_mapContainer.classList.add("hide");
		}

		// hide the map if there's no data to populate it
		function _showMap()
		{
			_mapContainer.classList.remove("hide");
		}

		// loads markers 
		function _loadMarkers()
		{
		  _markerBounds = new google.maps.LatLngBounds();
			_clearMarkers();

	    for(var m in _markerData)
	    {
	    	_loadMarker( _markerData[m] );
	    }	    
		}

		// clears all markers
		function _clearMarkers() 
		{
		  for (var i = 0; i < _markersArray.length; i++ ) {
		    _markersArray[i].setMap(null);
		  }
		  _markersArray = [];
		}

		// load a single marker
		function _loadMarker(markerData)
		{
			if (markerData['coordinates'] && markerData['coordinates'][0] && markerData['coordinates'][1])
			{
				var myLatlng = new google.maps.LatLng(markerData['coordinates'][1],markerData['coordinates'][0]);
				
				var url = '/organizations/'+markerData["_id"];
				var marker = new google.maps.Marker({
					id: markerData['id'],
					map: _map,
					title: markerData['name'],
					position: myLatlng,
					url:url,
					icon: {
				    path: google.maps.SymbolPath.CIRCLE,
				    scale: 5,
				    fillColor: "rgb(3,73,126)",
				    fillOpacity: 0.7,
				    strokeWeight: 1
				  }
				});

				_markersArray.push(marker);

				google.maps.event.addListener(marker, 'mouseover', function() {
				    
				    _markerInfo.innerHTML = this.title;
				    this.setZIndex(google.maps.Marker.MAX_ZINDEX);
				});

				google.maps.event.addListener(marker, 'mouseout', function() {
				    _markerInfo.innerHTML = "<span>Mouse over markers for details</span>";
				});

				google.maps.event.addListener(marker, 'click', function() {
				    window.location.href = this.url;
				});
				
				_markerBounds.extend(myLatlng);
				_map.fitBounds(_markerBounds);
			}
		}

		// returns the diameter of the map in miles
		function getRadius()
		{
			var bounds = _map.getBounds();

			var center = bounds.getCenter();
			var ne = bounds.getNorthEast();

			// r = radius of the earth in statute miles
			var r = 3963.0;  

			// Convert lat or lng from decimal degrees into radians (divide by 57.2958)
			var lat1 = center.lat() / 57.2958; 
			var lon1 = center.lng() / 57.2958;
			var lat2 = ne.lat() / 57.2958;
			var lon2 = ne.lng() / 57.2958;

			// radius = circle radius from center to Northeast corner of bounds
			var radius = ( r * Math.acos(Math.sin(lat1) * Math.sin(lat2) + 
			  				Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1)) );

			return radius;
		}

		// refresh the data
		// @param coordinates [Object] object with 'lat'/'lng' attributes on 
		function refresh(coordinates)
		{
			_loadData();
			_loadMarkers();
		}

	return {
		init:init,
		getRadius:getRadius,
		refresh:refresh
	};
});
