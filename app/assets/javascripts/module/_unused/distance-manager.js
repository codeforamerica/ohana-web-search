// manages appearance of distance in search results
var module = (function (module) {

	module.distanceManager = (function (distanceManager) {

		// PRIVATE PROPERTIES
		var distances; // array of distance

		// PUBLIC METHODS
		distanceManager.init = function()
		{
			distances = document.querySelectorAll("#results-list .distance");

			if (distances.length >0)
			{
				var totalDistance = webStorageProxy.getItem(searchOpManager.storageName);
				var totalWidth;
				var totalHeight;
				for(var d = 0;d<distances.length;d++)
				{
					var distanceBarBox = document.createElement("div");
						distanceBarBox.classList.add("distance-bar-box");
					var distanceBar = document.createElement("div");
						distanceBar.classList.add("distance-bar");
					var distanceLine = document.createElement("div");
						distanceLine.classList.add("distance-line");
					
					distances[d].appendChild(distanceBarBox);
					distanceBarBox.appendChild(distanceBar);
					distanceBarBox.appendChild(distanceLine);


					if (!totalWidth) totalWidth = distanceBarBox.offsetWidth;
					if (!totalHeight) totalHeight = distanceBarBox.offsetHeight;

					//console.log( totalWidth , distances[d].getAttribute("data-distance") , totalDistance );
					var travelDistance = (totalWidth*distances[d].getAttribute("data-distance"))/totalDistance;
					distanceBar.style.width = travelDistance+"px";
					distanceLine.style.width = travelDistance+"px";
				}
			}
		}

		return distanceManager;
	})({});

	return module;
})(module || {})