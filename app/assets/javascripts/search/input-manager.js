// handles ajax search functionality
define(['util/util'],
	function(util) {
  'use strict';

  	// PRIVATE PROPERTIES
		// search parameter values
		var _keyword,
				_location;

		var _callback; // function to execute when items are clicked

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;
			_keyword = document.getElementById("keyword");
			_location = document.getElementById("location");
			
			_keyword.addEventListener('focus',_inputClicked,true);
			_location.addEventListener('focus',_inputClicked,true);
			
			// if no ajax callback is given, don't register ajax calls
			if (callback)
			{
				document.getElementById('find-btn').addEventListener("click",_searchFormSubmittedHandler,false);
				_registerAjaxHooks();
			}
		}

		function refresh(scope)
		{
			_registerAjaxHooks(scope)
		}

		// getters and setters for keyword and location
		function getKeyword()
		{
			return _keyword.value;
		}

		function setKeyword(value)
		{
			_keyword.value = value;
		}

		function getLocation()
		{
			return _location.value;
		}

		function setLocation(value)
		{
			_location.value = value;
		}

		// PRIVATE METHODS
		// clear input fields when fields are clicked
		function _inputClicked(evt)
		{
			evt.target.value = ''; // clear input when user clicked on the field
		}

		// register all links with "ajax-link" class added as ajax-enabled links
		function _registerAjaxHooks(scope)
		{
			scope = scope || ""
			scope+=" .ajax-link";
			var lnks = document.querySelectorAll(scope);

			var curr;
			for (var l=0; l < lnks.length; l++)
			{
				curr = lnks[l];
				curr.addEventListener("click", _linkClickedHandler, false);
			}
		}

		function _searchFormSubmittedHandler(evt)
		{
			var params = util.getQueryParams(window.location.search);
			params.keyword = getKeyword();
			params.location = getLocation();
			params.page = 1;
			_callback.performSearch(params);

			evt.preventDefault();
			return false;
		}

		function _linkClickedHandler(evt)
		{
			var params = util.getQueryParams(this.search);
			var id = this.pathname.substring(this.pathname.lastIndexOf("/")+1, this.pathname.length);
			if (id != 'organizations')
				params.id = id;

			_callback.performSearch(params);
			
			evt.preventDefault();
			return false;
		}

	return {
		init:init,
		refresh:refresh,
		getKeyword:getKeyword,
		setKeyword:setKeyword,
		getLocation:getLocation,
		setLocation:setLocation
	};
});