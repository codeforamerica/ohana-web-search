// manages limiting the characters of the description
// on the details page and providing a more/less link to 
// toggle showing or hiding excess text
define(function() {
  'use strict';

		// PRIVATE PROPERTIES
		

		// PUBLIC METHODS
		function init()
		{
			var searchBox = document.getElementById('search-box');
			var categoryBox = document.getElementById('category-box');
			var catSearch = document.getElementById('category-search');
			var keywordSearch = document.getElementById('keyword-search');

			catSearch.addEventListener('click',function(){

				searchBox.classList.add('flip');
				searchBox.classList.remove('unflip');

				categoryBox.classList.add('unflip');
				categoryBox.classList.remove('flip');
			});

			keywordSearch.addEventListener('click',function(){

				searchBox.classList.add('unflip');
				searchBox.classList.remove('flip');

				categoryBox.classList.add('flip');
				categoryBox.classList.remove('unflip');
			});


		}


	return {
		init:init
	};
});