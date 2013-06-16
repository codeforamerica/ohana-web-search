// manages behavior of results view list vs maps setting
var module = (function (module) {

	module.resultViewManager = (function (resultViewManager) {

		// PRIVATE PROPERTIES
		var listViewButton; 
		var mapViewButton;
		var listView; 
		var mapView;
		var selected;

		resultViewManager.storageName = "resultviewpref";

		// PUBLIC METHODS
		resultViewManager.init = function()
		{
			listViewButton = document.getElementById("list-view-btn");
			mapViewButton = document.getElementById("map-view-btn");
			
			listView = document.getElementById("list-view");
			mapView = document.getElementById("map-view");
			
			// checks that required elements exist on the page.
			if ( listViewButton && mapViewButton && listView  && mapView )
			{
				listViewButton.addEventListener( "mousedown" , listClickHandler , false);
				mapViewButton.addEventListener( "mousedown" , mapClickHandler , false);

				if (webStorageProxy.getItem(resultViewManager.storageName) == "list"){
					selected = listViewButton;
					mapViewButton.disabled = "";
				}else{
					selected = mapViewButton;
					listViewButton.disabled = "";
				}

				selected.disabled = "disabled";
				if (selected == listViewButton) 
				{
					mapView.classList.add("hide");
					listView.classList.remove("hide");
				}
				else if (selected == mapViewButton)
				{
					listView.classList.add("hide");
					mapView.classList.remove("hide");
				}
			}
		}

		// PRIVATE METHODS
		function listClickHandler(evt)
		{
			webStorageProxy.setItem(resultViewManager.storageName , "list");
			resultViewManager.init();
		}

		function mapClickHandler(evt)
		{
			webStorageProxy.setItem(resultViewManager.storageName , "map");
			resultViewManager.init();
		}

		return resultViewManager;
		})({});

	return module;
})(module || {})