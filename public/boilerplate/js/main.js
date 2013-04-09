var main = (function () {
"use strict";

	var main = {};
	
	var splashScreen; // splash screen element
	var searchScreen; // search screen element
	var JSON; // loaded data

	// initalize the application
	main.init = function()
	{
		splashScreen = document.getElementById("splash-screen");
		searchScreen = document.getElementById("search-screen");
		
		var path = "/boilerplate/data/dbmock.json"; // load mock data
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
		$(splashScreen).fadeOut();
		$(searchScreen).fadeIn();
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