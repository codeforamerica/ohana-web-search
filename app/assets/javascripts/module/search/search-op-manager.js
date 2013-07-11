// manages search options
define(['util/web-storage-proxy'],function(webStorageProxy) {
  'use strict';

		// PUBLIC PROPERTIES
		var storageName = "hrl-searchop";

		// PRIVATE PROPERTIES
		var searchInput; // search input element
		var searchOptions; // search options area
		var searchRadius; // search radius drop-down
		var insideContent; // #inside-content section
		var resultsList; // #results-list section
		//var updateAlertBox; // #update-alert

		// PUBLIC METHODS
		function init()
		{
			searchInput = document.getElementById("location");
			searchInput.addEventListener("focus", _focusSearchOptionsHandler,false);
			searchInput.addEventListener("blur", _blurSearchOptionsHandler,false);

			searchOptions = document.getElementById("search-options-screen");
			if (searchOptions)
			{
				searchRadius = document.getElementById("radius");		
				if (!searchInput.value && searchRadius) searchRadius.disabled = true;
				webStorageProxy.setItem(storageName,searchRadius.value);
				//searchRadius.addEventListener("change",changeHandler,false);
			}
		}

		function _focusSearchOptionsHandler(evt)
		{
			if (searchOptions)
			{
				searchRadius.disabled = false;
			}
		}

		function _blurSearchOptionsHandler(evt)
		{
			if (!searchInput.value && searchOptions)
			{
				searchRadius.disabled = true;
			}
		}

		// handles change of search options
		/*function changeHandler(evt)
		{
			//webStorageProxy.setItem(searchOpManager.storageName,searchRadius.value);
			insideContent = document.getElementById("inside-content");
			resultsList = document.getElementById("results-list");
			updateAlertBox = document.getElementById("update-alert");
			if (!updateAlertBox)
			{
				updateAlertBox = document.createElement("section");
				updateAlertBox.id = "update-alert";
				updateAlertBox.innerHTML = "<button type='submit' form='search-form'>Update results!</button>";
				if (insideContent)
				{
					insideContent.appendChild(updateAlertBox);
					resultsList.style.opacity = 0.25;
				}
			}
		}*/

	return {
		init:init
	};
});
