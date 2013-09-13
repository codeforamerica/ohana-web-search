// handles ajax search functionality
define(['util/util'],function (util) {
  'use strict';

  	// PRIVATE PROPERTIES
		// search parameter values
		var _keyword,
				_location,
				_language;

		var _findBtn; // find button on homepage
		var _updateBtn; // update button on inside page

		var _callback; // function to execute when items are clicked

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;
			_keyword = document.getElementById("keyword");
			_location = document.getElementById("location");
			_language = document.getElementById("language");

			_findBtn = document.getElementById('find-btn');
			_updateBtn = document.getElementById('update-btn');

			// if no ajax callback is given, don't register ajax calls
			if (callback)
			{
				if (_updateBtn) _updateBtn.addEventListener("click",_searchFormSubmittedHandler,false);
				if (_findBtn) _findBtn.addEventListener("click",_searchFormSubmittedHandler,false);
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

		function getLanguage()
		{
			return _language.value;
		}

		function setLanguage(value)
		{
			if (value)
				_language.value = value;
		}

		// PRIVATE METHODS

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

		function _searchFormSubmittedHandler(evt)
		{
			var params = {};
			params.keyword = getKeyword();
			params.location = getLocation();
			params.language = getLanguage();
			params.page = 1;
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
		setLocation:setLocation,
		getLanguage:getLanguage,
		setLanguage:setLanguage
	};
});