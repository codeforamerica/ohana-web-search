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

			keyword = document.getElementById("keyword");
			location = document.getElementById("location");
			radius = document.getElementById("radius");
			
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
			lm.show({"fullscreen":false});
			
			var query = this.pathname+this.search;
			if (!query)
			{
				page = 1;/*document.getElementById("page").value;*/

				var values = {'keyword':keyword.value,
											'location':location.value,
											'radius':radius.value,
											'page':page
											}
				
				query = '/organizations'+util.queryString(values);
			}
			ajax.request(query, _callback);
			window.history.pushState({'ajax':true},null, query);

			evt.preventDefault();
			return false;
		}

		function _updateURL(evt) 
		{
			var params = util.getQueryParams(document.location.search);
			
			keyword.value = params.keyword || "";
			location.value = params.location || "";
			if (params.radius) radius.value = params.radius;
			if (location.value != "") radius.disabled = false;
			
			ajax.request(window.location.href, _callback);
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