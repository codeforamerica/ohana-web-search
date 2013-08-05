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
			_searchBox.classList.add('unflip');
			_searchBox.classList.remove('flip');

			_categoryBox.classList.add('flip');
			_categoryBox.classList.remove('unflip');

			storage.setItem(_storageID, 'KEYWORD');
		}

		function _showCategorySearch()
		{
			_searchBox.classList.add('flip');
			_searchBox.classList.remove('unflip');

			_categoryBox.classList.add('unflip');
			_categoryBox.classList.remove('flip');

			storage.setItem(_storageID, 'CATEGORY');
		}

	return {
		init:init
	};
});