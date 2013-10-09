// manages results maps view
define(['async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback','util/util'],function(util) {
  'use strict';

		// PRIVATE PROPERTIES
		var _map;
		var _markerData; // markers on the map
		var _markersArray; // array for storing markers
		var _markerBounds; // the bounds of the markers
		var _locationMarker; // the location of the current org

		//var _nearbyControl; // the show nearby locations button
		var _mapCanvas; // the details map div
		//var _nearbyControlIcon; // icon in the nearby locations button
		//var _nearbyControlTxt; // text in the nearby locations button

		//var _nearbyShowing; //whether or not the nearby locations are showing

		var _infoWindow = new google.maps.InfoWindow(); // info window to pop up on roll over

		// constants for map button text content
		//var NO_NEARBY = "NOTE: No nearby services at this location";
		//var SHOW_NEARBY = "Show nearby services";
		//var HIDE_NEARBY = "Hide nearby services";

		// PUBLIC METHODS
		function init()
		{
			//_nearbyControl = document.getElementById("show-nearby-control");
			_mapCanvas = document.getElementById("detail-map-canvas");
			//_nearbyShowing = false;
			_markersArray = [];

			if (_mapCanvas)
			{
				//_nearbyControlIcon = document.getElementById("show-nearby-control-icon");
				//_nearbyControlTxt = document.getElementById("show-nearby-control-text");

				_loadData();
				//_initControlText();

				var title = document.getElementById("detail-map-canvas-title");
				var lat = document.getElementById("detail-map-canvas-lat");
				var lng = document.getElementById("detail-map-canvas-lng");

				title = title.innerHTML;
				lat = lat.innerHTML;
				lng = lng.innerHTML;

			  var latLng = new google.maps.LatLng(lat,lng);

			  var mapOptions = {
			    zoom: 16,
			    center: latLng,
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
			  _map = new google.maps.Map(document.getElementById("detail-map-canvas"), mapOptions);

				_locationMarker = new google.maps.Marker({
						map: _map,
						title: title,
						position: latLng
					});

				refresh();
			}
		}

		// nearby map control was clicked
		// function _nearbyControlClicked(evt)
		// {
		// 	if (_nearbyShowing)
		// 	{
		// 		_hideNearby();
		// 		_nearbyShowing = false;
		// 	}
		// 	else
		// 	{
		// 		_showNearby();
		// 		_nearbyShowing = true;
		// 	}
		// 	refresh();
		// }

		// show the nearby markers
		// function _showNearby()
		// {
		// 	_loadMarkers();
	 //    var metadata = _markerData[_markerData.length-1];
		// 	var summaryText = "<span>"+metadata.count+" nearby services located</span>";
		// 	_nearbyControlTxt.innerHTML = summaryText+" • "+HIDE_NEARBY;
		// }

		// // hides the nearby markers
		// function _hideNearby()
		// {
		// 	_clearMarkers();
		// 	_nearbyControlTxt.innerHTML = SHOW_NEARBY;
		// }

		// loads the data
		function _loadData()
		{
			var nearby = document.getElementById("map-locations");
			if (nearby)
			{
				_markerData = JSON.parse(nearby.innerHTML);
		  	nearby.parentNode.removeChild(nearby); // remove script element
			}
		}

		// initializes nearby map control
		// function _initControlText()
		// {
		// 	if (_markerData)
		// 		{
		// 			_nearbyControl.classList.add('hover');
		// 			_nearbyControl.addEventListener("click", _nearbyControlClicked, false);
		// 			_nearbyControlTxt.innerHTML = SHOW_NEARBY;
		// 			_nearbyControlIcon.classList.remove('hide');
		// 		}
		// 		else
		// 		{
		// 			_nearbyControlTxt.innerHTML = NO_NEARBY;
		// 		}
		// }

		// loads markers
		function _loadMarkers()
		{
			if (_markerData)
			{
			  _markerBounds = new google.maps.LatLngBounds();
			  _markerBounds.extend(_locationMarker.position);

				_clearMarkers();

				var dataLength = _markerData.length;
		    for(var m = 0; m<dataLength-1; m++)
		    {
		    	_loadMarker( _markerData[m] );
		    }
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

				//var markerIcon = 'http://mt.google.com/vt/icon/text='+markerData['name'].substring(0,1)+'&psize=16&font=fonts/arialuni_t.ttf&color=ff330000&name=icons/spotlight/spotlight-waypoint-a.png&ax=44&ay=48&scale=1';
				var markerIcon = 'https://mts.googleapis.com/vt/icon/name=icons/spotlight/spotlight-waypoint-a.png&scale=0.5';

				var marker = new google.maps.Marker({
					id: markerData['id'],
					map: _map,
					title: markerData['name'],
					position: myLatlng,
					icon: markerIcon
				});

				_markersArray.push(marker);

				var agency = markerData['agency'] ? "<h2>"+markerData['agency']+"</h2>" : "";
				var content = "<h1>"+markerData['name']+"</h1>"+agency+"<p>Click map <img src='"+markerIcon+"'/> to view details</a></p>"
				_makeInfoWindowEvent(_map, _infoWindow, content, marker);

				google.maps.event.addListener(marker, 'click', _markerClickedHandler);

				_markerBounds.extend(myLatlng);

			}
		}

		// set the content in the info window
		function _makeInfoWindowEvent(map, infowindow, contentString, marker) {
			google.maps.event.addListener(marker, 'mouseover', function() {
				_infoWindow.setContent(contentString);
				_infoWindow.open(map, marker);
			});
		}

		// a location marker was clicked, perform a search for the organization details
		function _markerClickedHandler(evt)
		{
			window.location.href = '/organizations/'+this.id+(window.location.search);
		}

		// refresh the data
		// @param coordinates [Object] object with 'lat'/'lng' attributes on
		function refresh()
		{
			//if (_zoomListener) google.maps.event.removeListener(_zoomListener);
			//if (_tilesLoadedListener) google.maps.event.removeListener(_tilesLoadedListener);
			//_loadMarkers();
			//_tilesLoadedListener = google.maps.event.addListener(_map,"tilesloaded",_mapLoaded);
			if (_markersArray.length > 0)
			{
				_map.fitBounds(_markerBounds);
			}
			else
			{
				_map.setZoom(16);
				_map.setCenter(_locationMarker.getPosition());
			}
		}

	return {
		init:init
	};
}, function (err) {
    //The errback, error callback
    //The error has a list of modules that failed
    var failedId = err.requireModules && err.requireModules[0];

    console.log("Map failed to load! Hiding map HTML code.",failedId);

		var mapContainer = document.getElementById('map-view');
		    mapContainer.classList.add('hide');
});
