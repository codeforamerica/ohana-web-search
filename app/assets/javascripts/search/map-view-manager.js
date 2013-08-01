// manages results maps view
define(['util/util'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _mapContainer;
		var _markerInfo; // info window that shows when markers are rolled over
		var _header; // map header content
		var _defaultHeaderContent;

		var _map;
		var _markerData; // markers on the map
		var _markersArray = []; // array for storing markers
		var _markerBounds;

		var _callback; // callback function for passing updates
		var _tilesLoadedListener; // listener for when the tiles have loaded
		var _zoomListener; // listener for when the map is zoomed
		var _panListener; // listener for when the map view is dragged

		var _locationMarker;
		var _locationName;
		var _locationCoords;

		//var _radiusCircle; // debugging aid to see radius of search area

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;
			_mapContainer = document.getElementById("map-view");
			_header = document.getElementById("map-search-results");
		  _defaultHeaderContent = _header.innerHTML;
			document.getElementById("map-canvas").classList.remove("hide");
				
		  var mapOptions = {
		    zoom: 4,
		    zoomControl: false,
		    panControl: false,
		    streetViewControl: false,
		    mapTypeControl: false,
		    scaleControl: true,
		    scaleControlOptions: {
        position: google.maps.ControlPosition.RIGHT_BOTTOM
    		},
		    mapTypeId: google.maps.MapTypeId.ROADMAP,
		    center: new google.maps.LatLng(37.485215,-122.236355)
		  }
		  _map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		  _markerInfo = document.getElementById("marker-info");

		  refresh();  
		}

		// register events on the map
		function _mapLoaded(evt)
		{
			google.maps.event.removeListener(_tilesLoadedListener);
			//_zoomListener = google.maps.event.addListener(_map,"zoom_changed",_mapZoomed);
			//_panListener = google.maps.event.addListener(_map,"dragend",_mapDragged);
		}

		/*
		// from http://stackoverflow.com/questions/6048975/google-maps-v3-how-to-calculate-the-zoom-level-for-a-given-bounds
		function _zoomToRadius(radius)
		{
			var pixelWidth = _map.offsetWidth;
			var GLOBE_WIDTH = 256; // a constant in Google's map projection
			var west = sw.lng();
			var east = ne.lng();
			var angle = east - west;
			if (angle < 0) {
			  angle += 360;
			}
			var zoom = Math.round(Math.log(pixelWidth * 360 / angle / GLOBE_WIDTH) / Math.LN2);
		}
		*/

		// handler for performing a search and reverse geolocation after dragging the map
		function _mapDragged(evt)
		{
			var params = {};
					params.location = _map.getCenter().lat()+","+_map.getCenter().lng();
					params.radius = getRadius()/2;
							_callback.performSearch(params);
							_locationName = results[1].formatted_address;
							_locationCoords = _map.getCenter();
							_addLocationMarker();

					var geocoder = new google.maps.Geocoder();
					geocoder.geocode({'latLng': _map.getCenter()}, function(results, status) {
			    if (status == google.maps.GeocoderStatus.OK) {
			      if (results[1]) {
			        params.location = results[1].formatted_address;
			        params.radius = getRadius()/2;
							_callback.performSearch(params);
							_locationName = results[1].formatted_address;
							_locationCoords = _map.getCenter();
							_addLocationMarker();
			      } else {
			        console.log('No results found');
			      }
			    } else {
			      console.log('Geocoder failed due to: ' + status);
			    }
			  });
		}

		// handler for performing a search after zooming the map
		function _mapZoomed(evt)
		{
			var params = {};
					params.radius = Math.round(getRadius());
					params.location = _map.getCenter().lat()+","+_map.getCenter().lng();

					var geocoder = new google.maps.Geocoder();
					geocoder.geocode({'latLng': _map.getCenter()}, function(results, status) {
			    if (status == google.maps.GeocoderStatus.OK) {
			      if (results[1]) {
			        params.location = results[1].formatted_address;
							_callback.performSearch(params);
			      } else {
			        console.log('No results found');
			      }
			    } else {
			      console.log('Geocoder failed due to: ' + status);
			    }
			  });
		}

		/*
		// used for debug purposes
		function _addRadiusCircle()
		{
			if (_radiusCircle)
			{
				_radiusCircle.setPosition(_locationCoords);
			}
			else
			{
				_radiusCircle = new google.maps.Circle({
				  map: _map,
				  radius: (getRadius()*1609.34)/2,    // convert radius to meters
				  fillOpacity: 0,
				  strokeColor: '#AA0000',
				  strokeWeight: 1
				});
				_radiusCircle.bindTo('center', _locationMarker, 'position');
			}
		}
		*/

		// add a marker for the center search location
		function _addLocationMarker()
		{
			if (_locationMarker)
			{
				_locationMarker.setPosition(_locationCoords);
			}
			else
			{
				_locationMarker = new google.maps.Marker({
					map: _map,
					title: _locationName,
					position: _locationCoords,
					icon: {
				    path: google.maps.SymbolPath.CIRCLE,
				    scale: 3,
				    fillColor: "red",
				    fillOpacity: 0.7,
				    strokeWeight: 0
				  }
				});
			}
		}

		// loads markers 
		function _loadMarkers()
		{
			var locations = document.getElementById("map-locations");
			if (locations)
			{
				_markerData = JSON.parse(locations.innerHTML);
		  	locations.parentNode.removeChild(locations); // remove script element
			  _markerBounds = new google.maps.LatLngBounds();
				_clearMarkers();

				var dataLength = _markerData.length;
		    for(var m = 0; m<dataLength-1; m++)
		    {
		    	_loadMarker( _markerData[m] );
		    }
		    var metadata = _markerData[dataLength-1];
		    var summaryText = "<span>"+metadata.count+" of "+metadata.total+" results located!</span>";
				_header.innerHTML = _defaultHeaderContent+" "+summaryText;
				_markerInfo.innerHTML = "Mouse over markers for details";
			}
			else
			{
				// no entries found
				_clearMarkers();
				//document.getElementById("map-canvas").classList.add("hide");
				_header.innerHTML = "No results located!";
				_markerInfo.innerHTML = "";
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
				
				var marker = new google.maps.Marker({
					id: markerData['id'],
					map: _map,
					title: markerData['name'],
					position: myLatlng,
					icon: {
				    path: google.maps.SymbolPath.CIRCLE,
				    scale: 5,
				    fillColor: "rgb(3,73,126)",
				    fillOpacity: 0.7,
				    strokeWeight: 1,
				    strokeOpacity: 0.3
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

				google.maps.event.addListener(marker, 'click', _markerClickedHandler);
				
				_markerBounds.extend(myLatlng);
				
			}
		}

		// a location marker was clicked, perform a search for the organization details
		function _markerClickedHandler(evt)
		{
			var params = {'id':this.id}
			params.keyword = document.getElementById('keyword').value;
			params.location = document.getElementById('location').value;
			_callback.performSearch(params);
		}

		// returns the diameter of the map in miles
		function _getRadius()
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

		// set the map zoom level to a particular radius (in miles)
		function _setZoom(radius)
		{
			var radiusToZoom = Math.round(14-Math.log(radius)/Math.LN2);
			_map.setZoom(_radiusToZoom(radius));
		}

		// refresh the data
		// @param coordinates [Object] object with 'lat'/'lng' attributes on 
		function refresh()
		{
			if (_zoomListener) google.maps.event.removeListener(_zoomListener);
			if (_tilesLoadedListener) google.maps.event.removeListener(_tilesLoadedListener);
			_loadMarkers();
			_tilesLoadedListener = google.maps.event.addListener(_map,"tilesloaded",_mapLoaded);
			if (_markersArray.length > 0)
				_map.fitBounds(_markerBounds);
		}

	return {
		init:init,
		refresh:refresh
	};
});
