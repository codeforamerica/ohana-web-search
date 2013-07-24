// handles ajax search functionality
define(['app/loading-manager','util/ajax','util/util','search/input-manager','search/pagination-manager','search/map-view-manager'],
	function(lm,ajax,util,inputs,pagination,map) {
  'use strict';
		
		var _resultsContainer; // area of HTML to refresh with ajax

		var _callback; // callback object for handling ajax success/failure

		var _ajaxCalled = false; // boolean for when the ajax has been call the first time 

		function init()
		{
			_resultsContainer = document.getElementById('results-container');

			inputs.init(_ajaxSearchHandler); // initialize search form and ajax links
			pagination.init(_ajaxSearchHandler); // initialize pagination
			map.init(_ajaxSearchHandler); // initalize map

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
			
			var keyword = params.keyword || "";
			var location = params.location || "";

			inputs.setKeyword(keyword);
			inputs.setLocation(location);

			if ( _ajaxCalled || (evt.state && evt.state.ajax) ){
				lm.show({"fullscreen":false});
				ajax.request(window.location.href, _callback);
			}
		}


		// @return [Object] keyword, location, radius, and page search paramter values
		function _retrieveSearchValues(page,keyword,location,radius)
		{
			var values = {};
			values.page = page || pagination.getPage();
			values.keyword = keyword || inputs.getKeyword();
			values.location = location || inputs.getLocation();
			values.radius = radius || map.getRadius();

			return values;
		}

		function _ajaxSearchHandler(evt)
		{			
			lm.show({"fullscreen":false});
			
			var query;

			if (this)
				query = this.pathname+this.search;
	
			if (!query)
				query = '/organizations'+util.queryString(_retrieveSearchValues(1));

			ajax.request(query, _callback);
			window.history.pushState({'ajax':true}, null, query);

			if (evt)
				evt.preventDefault();
			return false;
		}

		
		function _success(evt)
		{
			_ajaxCalled = true;
			_resultsContainer.innerHTML = evt.content;
			
			pagination.refresh(); // refresh pagination
			input.refresh("#results-container"); // refresh search inputs
			map.refresh(); // refresh map

			lm.hide(); // hide loading manager
		}

		function _failure(evt)
		{
			console.log('ajaxsearch failure',evt);
		}

	return {
		init:init
	};
});