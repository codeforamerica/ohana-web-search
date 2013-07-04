// handles ajax functionality
define(['jquery'],function($) {
  'use strict';

		function request(query,callback)
		{
			console.log("ajax request",query)
			if (callback)
				$.ajax(query).done(callback.done).fail(callback.fail)
			else
				$.ajax(query).done(_success).fail(_failure);
		}

		// default callbacks
		function _success(evt)
		{
			console.log('success',evt);
		}

		function _failure(evt)
		{
			console.log('error',evt);
		}

	return {
		request:request
	};
});