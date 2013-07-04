// manages behavior of results view list vs maps setting
define(['web-storage-proxy'],function(webStorageProxy) {
  'use strict';
	
		// PRIVATE PROPERTIES
		var listViewButton; 
		var mapViewButton;
		var listView; 
		var mapView;
		var selected;

		var storageName = "resultviewpref";

		// PUBLIC METHODS
		function init()
		{
			listViewButton = document.getElementById("list-view-btn");
			mapViewButton = document.getElementById("map-view-btn");
			
			listView = document.getElementById("list-view");
			mapView = document.getElementById("map-view");
			
			// checks that required elements exist on the page.
			if ( listViewButton && mapViewButton && listView  && mapView )
			{
				listViewButton.addEventListener( "mousedown" , _listClickHandler , false);
				mapViewButton.addEventListener( "mousedown" , _mapClickHandler , false);

				if (webStorageProxy.getItem(storageName) == "list"){
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
		function _listClickHandler(evt)
		{
			webStorageProxy.setItem(storageName , "list");
			init();
		}

		function _mapClickHandler(evt)
		{
			webStorageProxy.setItem(storageName , "map");
			init();
		}

	return {
		init:init
	};
});