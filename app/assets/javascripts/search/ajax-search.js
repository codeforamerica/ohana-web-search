// handles ajax search functionality
define(['app/loading-manager','util/ajax','util/util','detail/detail-init','result/result-init'],
	function(lm,ajax,util,detail,result) {
  'use strict';
	
		var _nextBtn;
		var _prevBtn;

		var _resultsContainer;

		var _callback; // callback object for handling ajax success/failure

		var _ajaxCalled = false; // boolean for when the ajax has been call the first time 

		// search parameter values
		var _keyword,_location,_radius,_page;

		function init()
		{
			_resultsContainer = document.getElementById('results-container');

			_initPagination();

			// init callback hooks for ajax search
			_callback = {
				'done' : _success,
				'fail' : _failure
			}

			_keyword = document.getElementById("keyword");
			_location = document.getElementById("location");
			_radius = document.getElementById("radius");
			
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
				_page = 1;/*document.getElementById("page").value;*/

				var values = {'keyword':_keyword.value,
											'location':_location.value,
											'radius':_radius.value,
											'page':_page
											}
				
				query = '/organizations'+util.queryString(values);
			}
			ajax.request(query, _callback);
			window.history.pushState({'ajax':true}, null, query);

			evt.preventDefault();
			return false;
		}

		function _updateURL(evt) 
		{
			var params = util.getQueryParams(document.location.search);
			
			_keyword.value = params.keyword || "";
			_location.value = params.location || "";
			if (params.radius) _radius.value = params.radius;
			if (location.value != "") _radius.disabled = false;
			
			if ( _ajaxCalled || (evt.state && evt.state.ajax) ){
				lm.show({"fullscreen":false});
				ajax.request(window.location.href, _callback);
			}
		}

		function _initPagination()
		{
			_nextBtn = document.querySelector('.pagination.next');
			_prevBtn = document.querySelector('.pagination.prev');

			if (_nextBtn && _prevBtn)
			{
				_nextBtn.addEventListener("click",_ajaxSearchHandler,false);
				_prevBtn.addEventListener("click",_ajaxSearchHandler,false);
			}
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
			_ajaxCalled = true;
			_resultsContainer.innerHTML = evt.content;
			
			result.init();
			detail.init();

			_initPagination();
			_registerAjaxHooks();
			 _updateTitle();

			lm.hide(); // hide loading manager
		}

		function _failure(evt)
		{
			console.log('ajaxsearch failure',location.href,evt);
		}

	return {
		init:init
	};
});