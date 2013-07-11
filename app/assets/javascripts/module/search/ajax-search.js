// handles ajax search functionality
define(['app/loading-manager','util/ajax','util/util','map-view-manager','result-view-manager'],
	function(lm,ajax,util,mapViewManager,resultViewManager) {
  'use strict';
	
		var busyScreen;
		var nextBtn;
		var prevBtn;

		var resultsContainer;

		// search parameter values
		var keyword,location,radius,page;

		function init()
		{
			resultsContainer = document.getElementById('results-container');

			_initPagination();

			document.getElementById('find-btn').addEventListener("click",_ajaxSearchHandler,false);
			document.getElementById('radius').addEventListener("change",_ajaxSearchHandler,false);
		}

		function _ajaxSearchHandler(evt)
		{
			lm.show({"fullscreen":false});
			evt.preventDefault();
			
			keyword = document.getElementById("keyword").value;
			location = document.getElementById("location").value;
			radius = document.getElementById("radius").value;
			page = document.getElementById("page").value;

			var values = {'keyword':keyword,
										'location':location,
										'radius':radius,
										'page':page
										}
			
			var query = '/organizations'+util.queryString(values);
			
			var callback = {
				'done' : _success,
				'fail' : _failure
			}

			ajax.request(query, callback);
			window.history.pushState({},"", query);

			return false;
		}

		function _initPagination()
		{
			nextBtn = document.querySelector('.pagination.next');
			prevBtn = document.querySelector('.pagination.prev');

			if (nextBtn && prevBtn)
			{
				nextBtn.addEventListener("click",_nextPageHandler,false);
				prevBtn.addEventListener("click",_prevPageHandler,false);
			}
		}

		function _nextPageHandler(evt)
		{
			evt.preventDefault();
			var page = document.getElementById("page").value;
			document.getElementById("page").value = Number(page)+1;
			_ajaxSearchHandler(evt);
		}

		function _prevPageHandler(evt)
		{
			evt.preventDefault();
			var page = document.getElementById("page").value;
			document.getElementById("page").value = Number(page)-1;
			_ajaxSearchHandler(evt);
		}

		function _success(evt)
		{
			resultsContainer.innerHTML = evt.content;
			resultViewManager.init();
			_initPagination();
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