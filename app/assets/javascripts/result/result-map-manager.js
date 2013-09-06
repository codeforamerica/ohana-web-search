// manages results maps view
define(['async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'],function (map) {
  'use strict';

		// PRIVATE PROPERTIES
		var _map; // the map div that the Google map loads into
		var _mapCanvas; // the parent element of _map
		var _mapViewControl; // the element that controls the expanding/contracting of the map
		var _atMaxSize = false; // whether the map is at its max size or not

		var _markerData; // markers on the map
		var _markersArray = []; // array for storing markers
		var _markerBounds; // the bounds of the markers

		// constants for map button text content
		var LARGER_MAP_TEXT = "Display small map";
		var SMALLER_MAP_TEXT = "Display large map";

		var _callback; // callback to handoff search to when nearby location is clicked

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;

			var mapContainer = document.getElementById('map-view');

			if (mapContainer)
			{
				_mapCanvas = document.getElementById("map-canvas");
				_mapViewControl = document.getElementById('map-view-control');
				_mapViewControl.innerHTML = SMALLER_MAP_TEXT;

			  var mapOptions = {
			    zoom: 16,
			    scrollwheel: false,
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

			  _map = new google.maps.Map(_mapCanvas, mapOptions);

			  _mapViewControl.addEventListener('click', _mapViewControlClicked, false);

			  refresh();
			}
		}

		// map view control clicked
		function _mapViewControlClicked(evt)
		{
			if (_atMaxSize)
			{
				_mapCanvas.classList.remove('max');
				_mapViewControl.innerHTML = SMALLER_MAP_TEXT;
				_atMaxSize = false;
			}
			else
			{
				_mapCanvas.classList.add('max');
				_mapViewControl.innerHTML = LARGER_MAP_TEXT;
				_atMaxSize = true;
			}
			google.maps.event.trigger(_map, "resize");
			if (_markersArray.length > 0)
				_map.fitBounds(_markerBounds);
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
			}
			else
			{
				// no entries found
				_clearMarkers();
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

				var markerIcon = 'https://mts.googleapis.com/vt/icon/name=icons/spotlight/spotlight-waypoint-a.png&scale=0.7';
				//var markerIcon = 'http://mt.google.com/vt/icon/text='+markerData['name'].substring(0,1)+'&psize=16&font=fonts/arialuni_t.ttf&color=ff330000&name=icons/spotlight/spotlight-waypoint-a.png&ax=44&ay=48&scale=1';

				var marker = new google.maps.Marker({
					id: markerData['id'],
					map: _map,
					title: markerData['name'],
					position: myLatlng,
					icon: markerIcon
				});

				_markersArray.push(marker);

				/*
				google.maps.event.addListener(marker, 'mouseover', function() {
				    _markerInfo.innerHTML = this.title;
				    this.setZIndex(google.maps.Marker.MAX_ZINDEX);
				});

				google.maps.event.addListener(marker, 'mouseout', function() {
				    _markerInfo.innerHTML = "<span>Mouse over markers for details</span>";
				});
				*/
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

		// refresh the data
		// @param coordinates [Object] object with 'lat'/'lng' attributes on
		function refresh()
		{
			//if (_zoomListener) google.maps.event.removeListener(_zoomListener);
			//if (_tilesLoadedListener) google.maps.event.removeListener(_tilesLoadedListener);
			_loadMarkers();
			//_tilesLoadedListener = google.maps.event.addListener(_map,"tilesloaded",_mapLoaded);
			if (_markersArray.length > 0)
				_map.fitBounds(_markerBounds);

			//(optional) restore the zoom level after the map is done scaling
			//var listener = google.maps.event.addListener(_map, "idle", function () {
			//    _map.setZoom(10);
			//    google.maps.event.removeListener(listener);
			//});

		}

	return {
		init:init
	};
});
