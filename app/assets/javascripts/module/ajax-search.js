// handles ajax functionality
var module = (function (module) {

	module.ajaxSearch = (function (ajaxSearch) {

		var busyScreen;
		var nextBtn;
		var prevBtn;

		var searchScreen;

		// search parameter values
		var keyword,location,radius,page;

		ajaxSearch.init = function()
		{
			searchScreen = document.getElementById('search-content');

			initPagination();

			document.getElementById('find-btn').addEventListener("click",ajaxClickHandler,false);
			document.getElementById('radius').addEventListener("change",ajaxClickHandler,false);
		}

		function ajaxClickHandler(evt)
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
			
			var query = '/organizations/'+module.util.queryString(values);
			var callback = {
				'done' : success,
				'fail' : failure
			}

			module.ajax.request(query, callback);
			window.history.pushState({},"", query);
		}

		function initPagination()
		{
			nextBtn = document.querySelector('.pagination.next');
			prevBtn = document.querySelector('.pagination.prev');

			if (nextBtn && prevBtn)
			{
				nextBtn.addEventListener("click",nextPageHandler,false);
				prevBtn.addEventListener("click",prevPageHandler,false);
			}
		}

		function nextPageHandler(evt)
		{
			evt.preventDefault();
			var page = document.getElementById("page-number").value;
			document.getElementById("page-number").value = Number(page)+1;
			ajaxClickHandler(evt);
		}

		function prevPageHandler(evt)
		{
			evt.preventDefault();
			var page = document.getElementById("page-number").value;
			document.getElementById("page-number").value = Number(page)-1;
			ajaxClickHandler(evt);
		}

		function success(evt)
		{
			searchScreen.innerHTML = evt.content;
			module.mapViewManager.init(); // re-initialize map view
			module.resultViewManager.init();
			initPagination();
		}

		function failure(evt)
		{
			console.log('ajaxsearch failure',evt);
			searchScreen.removeChild(busyScreen);
		}

		return ajaxSearch;
	})({});

	return module;
})(module || {})