// handles ajax search functionality
define(['ajax','util','map-view-manager','result-view-manager'],
	function(ajax,mapViewManager,resultViewManager) {
  'use strict';
	
		var busyScreen;
		var nextBtn;
		var prevBtn;

		var searchScreen;

		// search parameter values
		var keyword,location,radius,page;

		function init()
		{
			searchScreen = document.getElementById('search-content');

			_initPagination();

			document.getElementById('find-btn').addEventListener("click",_ajaxClickHandler,false);
			document.getElementById('radius').addEventListener("change",_ajaxClickHandler,false);
		}

		function _ajaxClickHandler(evt)
		{
			busyScreen = document.createElement('div');
			busyScreen.id = 'busy-screen';
			busyScreen.innerHTML = '<h1>updating...</h1>';
			searchScreen.appendChild(busyScreen);

			evt.preventDefault();
			
			keyword = document.getElementById("keyword").value;
			location = document.getElementById("location").value;
			radius = document.getElementById("radius").value;
			page = document.getElementById("page-number").value;

			var values = {'keyword':keyword,
										'location':location,
										'radius':radius,
										'page':page
										}
			
			var query = '/organizations/'+util.queryString(values);
			var callback = {
				'done' : success,
				'fail' : failure
			}

			ajax.request(query, callback);
			window.history.pushState({},"", query);
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
			var page = document.getElementById("page-number").value;
			document.getElementById("page-number").value = Number(page)+1;
			_ajaxClickHandler(evt);
		}

		function _prevPageHandler(evt)
		{
			evt.preventDefault();
			var page = document.getElementById("page-number").value;
			document.getElementById("page-number").value = Number(page)-1;
			_ajaxClickHandler(evt);
		}

		function _success(evt)
		{
			searchScreen.innerHTML = evt.content;
			mapViewManager.init(); // re-initialize map view
			resultViewManager.init();
			_initPagination();
		}

		function _failure(evt)
		{
			console.log('ajaxsearch failure',evt);
			searchScreen.removeChild(busyScreen);
		}

	return {
		init:init
	};
});