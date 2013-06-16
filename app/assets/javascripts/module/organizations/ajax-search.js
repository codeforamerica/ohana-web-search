// handles ajax functionality
var module = (function (module) {

	module.ajaxSearch = (function (ajaxSearch) {

		// search parameter values
		var keyword,location,radius,page;

		ajaxSearch.init = function()
		{
			keyword = document.getElementById("keyword").value;
			location = document.getElementById("location").value;
			radius = document.getElementById("radius").value;
			page = document.getElementById("page-number").value;

			console.log(keyword,location,radius,page);
		}

		return ajaxSearch;
	})({});

	return module;
})(module || {})