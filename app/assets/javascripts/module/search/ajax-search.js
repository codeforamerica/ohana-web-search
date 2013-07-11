// handles ajax search functionality
define(['app/loading-manager','util/ajax','util/util','map-view-manager','result-view-manager'],
	function(lm,ajax,util,mapViewManager,resultViewManager) {
  'use strict';
	
		var busyScreen;
		var nextBtn;
		var prevBtn;

		var resultsContainer;

		var _callback;

		// search parameter values
		var keyword,location,radius,page;

		function init()
		{
			resultsContainer = document.getElementById('results-container');

			_initPagination();

			// init callback hooks for ajax search
			_callback = {
				'done' : _success,
				'fail' : _failure
			}

			document.getElementById('find-btn').addEventListener("click",_ajaxSearchHandler,false);
			document.getElementById('radius').addEventListener("change",_ajaxSearchHandler,false);
		  window.addEventListener("popstate", _updateURL);
			_registerAjaxHooks();
		}

		// register all links to organizations as ajax-enabled links
		function _registerAjaxHooks()
		{
			var lnks = document.querySelectorAll(".ajax-link");

			var curr;
			for (var l=0; l < lnks.length; l++)
			{
				curr = lnks[l];
				curr.addEventListener("click", _ajaxSearchHandler, false);
			}
		}

		function _ajaxSearchHandler(evt)
		{			
			evt.preventDefault();

			lm.show({"fullscreen":false});
			
			var query = this.pathname+this.search;
			if (!query)
			{			
				keyword = document.getElementById("keyword").value;
				location = document.getElementById("location").value;
				radius = document.getElementById("radius").value;
				page = 1;/*document.getElementById("page").value;*/

				var values = {'keyword':keyword,
											'location':location,
											'radius':radius,
											'page':page
											}
				
				query = '/organizations'+util.queryString(values);
			}
			ajax.request(query, _callback);
			window.history.pushState({'ajax':true},null, query);

			return false;
		}

		function _updateURL(evt) {
			//ajax.request(window.location.pathname, _callback);
			if (evt.state && evt.state.ajax)
			{
				window.location.href = window.location.href;
			}
		}

		function _initPagination()
		{
			nextBtn = document.querySelector('.pagination.next');
			prevBtn = document.querySelector('.pagination.prev');

			if (nextBtn && prevBtn)
			{
				nextBtn.addEventListener("click",_ajaxSearchHandler,false);
				prevBtn.addEventListener("click",_ajaxSearchHandler,false);
			}
		}

		function _success(evt)
		{
			resultsContainer.innerHTML = evt.content;
			resultViewManager.init();
			_initPagination();
			_registerAjaxHooks();
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