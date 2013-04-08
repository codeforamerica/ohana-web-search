var main = (function () {
"use strict";

	var main = {};
	
	var JSON; // loaded data

	// initalize the application
	main.init = function()
	{
		var path = "data/dbmock.json"; // load mock data
		$.getJSON(path, function(response){
		   JSON = response;
		})
		
		.success(function() { dataLoadedSuccess(); })
		.error(function() { dataLoadedError(); })
		.complete(function() { dataLoadedComplete(); });
	}

	// functions for JSON loading success
	function dataLoadedSuccess()
	{
		console.log("data loaded successful!");
	}
	
	function dataLoadedError()
	{
		console.log("error loading data!");
	}
	
	function dataLoadedComplete()
	{
		console.log("completed loading of data!");
	}

// return internally scoped var as value of globally scoped object
return main;

})();