// handles ajax functionality
var module = (function (module) {

	module.ajax = (function (ajax) {

		ajax.init = function()
		{
			
		}

		ajax.request = function(query)
		{
			$.ajax(query).done(success).fail(failure);
		}

		function success(evt)
		{
			console.log('success',evt);
		}

		function failure(evt)
		{
			console.log('error',evt);
		}

		return ajax;
	})({});

	return module;
})(module || {})