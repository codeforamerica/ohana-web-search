/* Application functionality */

var main = (function () {
"use strict";
	var main = {};

	// initalize the application
	main.init = function()
	{
		dataloader.init(); // initialize data load
	}

	//=================================================================================
	// JSON data loader
	var dataloader = (function(){
		var dataloader = {};

		var JSON; // loaded data

		var splashScreen;

		dataloader.init = function()
		{
			splashScreen = document.getElementById("splash-screen");
			
			var path = "/boilerplate/data/dbmock.json"; // load mock data
			$.getJSON(path, function(response){
			   JSON = response;
			})
			
			.success(function() { dataLoadedSuccess(); })
			.error(function() { dataLoadedError(); })
			.complete(function() { dataLoadedComplete(); });
		}

		// PRIVATE FUNCTIONS
		// functions for JSON loading success
		function dataLoadedSuccess()
		{
			console.log("data loaded successful!");
			$(splashScreen).fadeOut();
			search.init(); //initialize search form
		}
		
		function dataLoadedError()
		{
			console.log("error loading data!");
		}
		
		function dataLoadedComplete()
		{
			console.log("completed JSON call! (Regardless of success or failure!)");
		}

		// PUBLIC FUNCTIONS
		// return data based on query
		main.getData = function(query)
		{
			// currently the query does nothing, we just return the mock JSON object
			return JSON;
		}

		return dataloader;
	})();

	//=================================================================================
	// Search functionality - handles search queries
	var search = (function () {
		var search = {};

		var searchBtn;
		var mainContent;
		var searchTerm;

		// initalize the application
		search.init = function()
		{
			searchBtn = document.querySelector("#search-btn");
			mainContent = document.querySelector("#main-content")
			searchTerm = document.querySelector("#search-term");

			message.init(); // initialize message box
			
			searchBtn.addEventListener( "mousedown" , searchBtnClicked );
			$(mainContent).fadeIn();
		}

		// search button was clicked
		function searchBtnClicked(evt)
		{
			message.display("successfully clicked!");
			lookupData(main.getData(), searchTerm.value);
		}

		function lookupData(data,query)
		{
			var entry = data["000"]["name"];
			if ( entry == query )
			{
				console.log("Query Successful!");
			}		
		}
		
		return search;
	})();

	//=================================================================================
	// Message dialog box - handles display and formatting of message box
	var message = (function(){
		var message = {};

		var messageBox;
		var messageArrow;
		var messageText;

		message.init = function()
		{
			messageBox = document.querySelector("#message-box");
			messageArrow = document.querySelector("#message-box .corner");
			messageText = document.querySelector("#message-box p");
		}

		message.display = function(msg)
		{
			messageText.innerHTML = msg;
			console.log(messageArrow.style.top );
			messageArrow.style.top = (Number(messageBox.style.height) - 7)*-1;
			console.dir(messageArrow );
		}

		return message;
	})();


// return internally scoped var as value of globally scoped object
return main;

})();

	


/*
// new app object template
var search = (function () {
"use strict";

	var search = {};

	// initalize the application
	search.init = function()
	{
		
	}

	return search;

})();
*/