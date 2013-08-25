// handles ajax search functionality
define(['app/loading-manager',
				'util/ajax','util/util',
				'search/input-manager',
				'detail/detail-init',
				'search/header-manager'],
	function(splash,ajax,util,inputs,detail,header) {
  'use strict';
		
		var _resultsContainer; // area of HTML to refresh with ajax

		var _callback; // callback object for handling ajax success/failure

		var _ajaxCalled = false; // boolean for when the ajax has been call the first time 

		var _requestType = {'RESULT':'index','DETAIL':'show'}

		function init()
		{
			_resultsContainer = document.getElementById('results-container');

			inputs.init(this); // initialize search form and ajax links
			header.init(); // initialize the header manager
			detail.init(this); // initializes detail scripts

			// init callback hooks for ajax search
			_callback = {
				'done' : _success,
				'fail' : _failure
			}

		  window.addEventListener("popstate", _updateURL);			
		}

		function _updateURL(evt) 
		{
			// TODO prevent ajax request when user follows 
			// a named anchor link to the same page they are currently on.

			if ( _ajaxCalled || (evt.state && evt.state.ajax) )
			{
				var params = util.getQueryParams(document.location.search);
				
				// set search field values
				var keyword = params.keyword || "";
				var location = params.location || "";

				inputs.setKeyword(keyword);
				inputs.setLocation(location);
			
				splash.show({"fullscreen":false});
				ajax.request(window.location.href, _callback);
			}
		}

		function performSearch(params)
		{
			splash.show({"fullscreen":false}); 

			var page = params.page || 1;
			var keyword = params.keyword || "";
			var location = params.location || "";
			var radius = params.radius || null;
			var id = params.id || null;

			inputs.setKeyword(keyword);
			inputs.setLocation(location);

			var query = '/organizations';
			if (id) query += '/'+id;
			if (page) query += "?page="+page;
			if (keyword) query += "&keyword="+encodeURIComponent(keyword);
			if (location) query += "&location="+encodeURIComponent(location);
			if (radius) query += "&radius="+radius;

			ajax.request(query, _callback);
			window.history.pushState({'ajax':true}, null, query);
		}

		function _updateTitle()
		{
			var suffix = document.title.substring(document.title.lastIndexOf("|"),document.title.length);
			var summary = document.getElementById("search-summary");
			if (!summary) summary = document.querySelector("#detail-info h1.name");
			summary = summary.getAttribute("title")+" "+suffix;
			document.title = summary;
		}
		
		function _success(evt)
		{
			window.scrollTo(0,0); // scrolls page to the top of the page when ajax finishes
			_ajaxCalled = true; // set ajax first-run flag
			_resultsContainer.innerHTML = evt.content; // update search results list
			
			if (evt.action == _requestType.DETAIL)
				detail.refresh(); // re-initializes details scripts
			
			inputs.refresh("#results-container"); // refresh search inputs
			header.init(); // re-initialize header manager

			_updateTitle(); // update page title
			splash.hide(); // hide loading manager
		}

		function _failure(evt)
		{
			console.log('ajaxsearch failure',location.href,evt);
		}

	return {
		init:init,
		performSearch:performSearch
	};
});