// manages limiting the characters of the description
// on the details page and providing a more/less link to 
// toggle showing or hiding excess text
define(['util/web-storage-proxy'],function(storage) {
  'use strict';

		// PRIVATE PROPERTIES
		var _searchBox;
		var _categoryBox;

		var _storageID = "util-web-storage-proxy";

		// PUBLIC METHODS
		function init()
		{
			_searchBox = document.getElementById('search-box');
			_categoryBox = document.getElementById('category-box');

			var catSearch = document.getElementById('category-search');
			var keywordSearch = document.getElementById('keyword-search');

			catSearch.addEventListener('click', _categoryClicked, false);
			keywordSearch.addEventListener('click', _keywordClicked, false);

			if (storage.getItem(_storageID) == 'KEYWORD')
			{
				_showKeywordSearch();
			}
			else
			{
				_showCategorySearch();
			}
		}

		// PRIVATE METHODS
		function _categoryClicked(evt)
		{
			_showCategorySearch();
		}

		function _keywordClicked(evt)
		{
			_showKeywordSearch();
		}

		function _showKeywordSearch()
		{
			_searchBox.classList.add('fade-in');
			_searchBox.classList.remove('fade-out');

			_categoryBox.classList.add('fade-out');
			_categoryBox.classList.remove('fade-in');

			storage.setItem(_storageID, 'KEYWORD');
		}

		function _showCategorySearch()
		{
			_searchBox.classList.add('fade-out');
			_searchBox.classList.remove('fade-in');

			_categoryBox.classList.add('fade-in');
			_categoryBox.classList.remove('fade-out');

			storage.setItem(_storageID, 'CATEGORY');
		}

	return {
		init:init
	};
});