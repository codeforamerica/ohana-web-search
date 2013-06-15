// manages behavior of popups
var module = (function (module) {

	module.resultSortManager = (function (resultSortManager) {

		// PRIVATE PROPERTIES
		var nameSortButton; 
		var distanceSortButton;
		var selected;

		var nameDescending = false;
		var distanceDescending = false;

		resultSortManager.storageName = "resultsortpref";

		// PUBLIC METHODS
		resultSortManager.init = function()
		{
			nameSortButton = document.getElementById("name-sort-btn");
			distanceSortButton = document.getElementById("distance-sort-btn");
			
			// checks that required elements exist on the page.
			if ( nameSortButton && distanceSortButton )
			{
				nameSortButton.addEventListener( "mousedown" , nameClickHandler , false);
				distanceSortButton.addEventListener( "mousedown" , distanceClickHandler , false);

				var settings = webStorageProxy.getItem(resultSortManager.storageName);
				if (settings["field"] == "name"){
					selected = nameSortButton;
					if (settings["descending"] == true) selected.innerHTML = "Name ▼";
					else selected.innerHTML = "Name ▲";
				}else{
					selected = distanceSortButton;
					if (settings["descending"] == true) selected.innerHTML = "Distance ▼";
					else selected.innerHTML = "Distance ▲";
				}
			}
		}

		// PRIVATE METHODS
		function nameClickHandler(evt)
		{
			nameDescending = !nameDescending;
			if (nameDescending){
				nameSortButton.innerHTML = "Name ▼";
				webStorageProxy.setItem(resultSortManager.storageName,{"field":"name","descending":true});
			}else{
				nameSortButton.innerHTML = "Name ▲";
				webStorageProxy.setItem(resultSortManager.storageName,{"field":"name","descending":false});
			}
		}

		function distanceClickHandler(evt)
		{
			distanceDescending = !distanceDescending;
			if (distanceDescending){
				distanceSortButton.innerHTML = "Distance ▼";
				webStorageProxy.setItem(resultSortManager.storageName,{"field":"distance","descending":true});
			}else{
				distanceSortButton.innerHTML = "Distance ▲";
				webStorageProxy.setItem(resultSortManager.storageName,{"field":"distance","descending":false});
			}
		}

		return resultSortManager;
	})({});

	return module;
})(module || {})
	