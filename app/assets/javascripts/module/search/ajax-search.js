// handles ajax search functionality
define(['app/loading-manager','util/ajax','util/util','search/input-manager','search/pagination-manager','search/map-view-manager'],
	function(splash,ajax,util,inputs,pagination,map) {
  'use strict';
		
		var _resultsContainer; // area of HTML to refresh with ajax

		var _callback; // callback object for handling ajax success/failure

		var _ajaxCalled = false; // boolean for when the ajax has been call the first time 

		function init()
		{
			_resultsContainer = document.getElementById('results-container');

			inputs.init(this); // initialize search form and ajax links
			pagination.init(this); // initialize pagination
			map.init(this); // initialize the map

			// init callback hooks for ajax search
			_callback = {
				'done' : _success,
				'fail' : _failure
			}

		  window.addEventListener("popstate", _updateURL);			
		}

		function _updateURL(evt) 
		{
			var params = util.getQueryParams(document.location.search);
			
			// set search field values
			var keyword = params.keyword || "";
			var location = params.location || "";

			inputs.setKeyword(keyword);
			inputs.setLocation(location);

			if ( _ajaxCalled || (evt.state && evt.state.ajax) )
			{
				splash.show({"fullscreen":false});
				ajax.request(window.location.href, _callback);
			}
		}

		function performSearch(params)
		{
			splash.show({"fullscreen":false}); 

			var page = params.page || 1;
			var keyword = params.keyword || null;
			var location = params.location || null;
			var radius = params.radius || null;
			var id = params.id || null;

			var query = '/organizations';
			if (id) query += '/'+id;
			if (page) query += "?page="+page;
			if (keyword) query += "&keyword="+keyword;
			if (location) query += "&location="+location;
			if (radius) query += "&radius="+radius;


			ajax.request(query, _callback);
			window.history.pushState({'ajax':true}, null, query);
		}
		
		function _success(evt)
		{
			_ajaxCalled = true; // set ajax first-run flag
			_resultsContainer.innerHTML = evt.content; // update search results list
			
			pagination.refresh(); // refresh pagination
			inputs.refresh("#results-container"); // refresh search inputs
			map.refresh(); // refresh the map

			splash.hide(); // hide loading manager
		}

		function _failure(evt)
		{
			console.log('ajaxsearch failure',evt);
		}

	return {
		init:init,
		performSearch:performSearch
	};
});