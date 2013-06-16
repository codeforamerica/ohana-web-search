// manages results maps view
var module = (function (module) {

	module.mapViewManager = (function (mapViewManager) {

		// PRIVATE PROPERTIES
		var map; // the created map

		// PUBLIC METHODS
		mapViewManager.init = function()
		{
			map = L.mapbox.map('map', 'examples.map-vyofok3q');
	    var locations = document.getElementById("map-locations");
	    var obj = JSON.parse(locations.innerHTML);

		    var geoJson = {
				    type: 'FeatureCollection',
				    features: []
				};

				for (var m in obj)
	    	{
	    		// if the coordinates actually exist for an entry
	    		if (obj[m]["coordinates"] != null && (obj[m]["coordinates"][0] != null || obj[m]["coordinates"][1] != null))
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
					    window.open(e.layer.feature.properties.url,"_self");
					});
				}
		}

		return mapViewManager;
	})({});

	return module;
})(module || {})
