// handles ajax functionality
var module = (function (module) {

	module.ajax = (function (ajax) {

		ajax.init = function()
		{
			
		}

		ajax.request = function(query,callback)
		{
			console.log("ajax request",query)
			if (callback)
				$.ajax(query).done(callback.done).fail(callback.fail)
			else
				$.ajax(query).done(success).fail(failure);
		}

		// default callbacks
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