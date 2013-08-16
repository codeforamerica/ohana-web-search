// manages results maps view
define(['util/util','async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _map;
		var _markerData; // markers on the map
		var _markersArray = []; // array for storing markers
		var _markerBounds;

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

			  
			  var locationMarker = new google.maps.Marker({
						map: _map,
						title: title,
						position: latlng
					});
			  
			  refresh();
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
				//_header.innerHTML = _defaultHeaderContent+" "+summaryText;
				//_markerInfo.innerHTML = "Mouse over markers for details";
			}
			else
			{
				// no entries found
				_clearMarkers();
				//document.getElementById("map-canvas").classList.add("hide");
				//_header.innerHTML = "No results located!";
				//_markerInfo.innerHTML = "";
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

				/*
				google.maps.event.addListener(marker, 'mouseover', function() {
				    _markerInfo.innerHTML = this.title;
				    this.setZIndex(google.maps.Marker.MAX_ZINDEX);
				});

				google.maps.event.addListener(marker, 'mouseout', function() {
				    _markerInfo.innerHTML = "<span>Mouse over markers for details</span>";
				});

				google.maps.event.addListener(marker, 'click', _markerClickedHandler);
				*/

				_markerBounds.extend(myLatlng);
				
			}
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
		}

	return {
		init:init
	};
});
