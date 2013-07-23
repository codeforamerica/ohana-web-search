// manages results maps view
define(['util/util'],function(util) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var _map;
		var _markerData; // markers on the map
		var _markerBounds;

		// PUBLIC METHODS
		function init()
		{
			_loadData();

		  var mapOptions = {
		    zoom: 4,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		  }
		  _map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		  _markerBounds = new google.maps.LatLngBounds();

		  _loadMarkers();
		 
      //google.maps.event.addListener(_map,"tilesloaded",_addMarkers);
      google.maps.event.addListener(_map, 'bounds_changed', _boundsChanged);

      

       /*
			// hackity hack to fix ajax issue where map variable was already
			// defined but was referring to a DOM node that had been removed
			// resulting in a blank map, but no errors.
			try{
				map = L.mapbox.map('map', 'examples.map-vyofok3q');
			}catch(e){}

	    var locations = document.getElementById("map-locations");
	    var obj = JSON.parse(locations.innerHTML);

	    var geoJson = {
			    type: 'FeatureCollection',
			    features: []
			};

			for (var m in obj)
    	{
    		// if the coordinates actually exist for an entry
    		if (obj[m]["coordinates"] != null && 
    				(obj[m]["coordinates"][0] != null || obj[m]["coordinates"][1] != null))
				{

	    		var url = '/organizations/'+obj[m]["_id"];
	    		var marker = {
				        type: 'Feature',
				        properties: {
				            title: obj[m]["name"],
				            'marker-color': '#f00',
				            'marker-size': 'small',
				            url: url
				        },
				        geometry: {
				            type: 'Point',
				            coordinates: obj[m]["coordinates"]
				        }
				    };

	    		geoJson["features"].push(marker);			    		
	    	}
    	}

    	// if there are features to show
    	if (geoJson.features.length > 0)
    	{
				// Pass features and a custom factory function to the map
				map.markerLayer.setGeoJSON(geoJson);
				
				map.fitBounds( map.markerLayer.getBounds() );
			
				map.markerLayer.on('mouseover', function(e) {
				    e.layer.openPopup();
				});

				map.markerLayer.on('mouseout', function(e) {
				    e.layer.closePopup();
				});

				map.markerLayer.on('click', function(e) {
				    e.layer.unbindPopup();
				    window.open(e.layer.feature.properties.url+util.queryString(),"_self");
				});
			}
			*/
		}

		// loads marker data
		function _loadData()
		{
			var locations = document.getElementById("map-locations");
	    _markerData = JSON.parse(locations.innerHTML);
		}

		// loads markers 
		function _loadMarkers()
		{
	    for(var m in _markerData)
	    {
	    	_loadMarker( _markerData[m] );
	    }	    
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
					position: myLatlng
				});
				
				_markerBounds.extend(myLatlng);
				_map.fitBounds(_markerBounds);
			}
		}

		// handler for when the map bounds are changed
		function _boundsChanged(evt)
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

			// distance = circle radius from center to Northeast corner of bounds
			var dis = r * Math.acos(Math.sin(lat1) * Math.sin(lat2) + 
			  Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1));
	}

	return {
		init:init
	};
});
