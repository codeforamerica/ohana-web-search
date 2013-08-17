// manages limiting the characters of the description
// on the details page and providing a more/less link to 
// toggle showing or hiding excess text
define(['util/web-storage-proxy'],function(storage) {
  'use strict';

		// PRIVATE PROPERTIES
		var _searchBox;
		var _locationBox;

		var _storageID = "util-web-storage-proxy";

		// PUBLIC METHODS
		function init()
		{
			_searchBox = document.getElementById('keyword-search-box');
			_locationBox = document.getElementById('location-search-box');

			var locationSearch = document.querySelector('#location-search-btn a');
			var keywordSearch = document.querySelector('#keyword-search-btn a');

			// the switcher anchors are hidden by default so they don't show up when JS is disabled
			locationSearch.classList.remove('hide');
			keywordSearch.classList.remove('hide');

			locationSearch.addEventListener('click', _locationClicked, false);
			keywordSearch.addEventListener('click', _keywordClicked, false);

			if (storage.getItem(_storageID) != 'KEYWORD')
			{
				_showKeywordSearch();
			}
			else
			{
				_showCategorySearch();
			}
		}

		// PRIVATE METHODS
		function _locationClicked(evt)
		{
			_showLocationSearch();
			evt.preventDefault();
			return false;
		}

		function _keywordClicked(evt)
		{
			_showKeywordSearch();
			evt.preventDefault();
			return false;
		}

		function _showKeywordSearch()
		{
			_searchBox.classList.remove('hide');
			_locationBox.classList.add('hide');
			document.getElementById('location').value = "";

			storage.setItem(_storageID, 'KEYWORD');
		}

		function _showLocationSearch()
		{
			_searchBox.classList.add('hide');
			_locationBox.classList.remove('hide');
			document.getElementById('keyword').value = "";			

			storage.setItem(_storageID, 'LOCATION');
		}

	return {
		init:init
	};
});