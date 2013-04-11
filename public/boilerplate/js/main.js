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

		// PRIVATE METHODS
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

		// PUBLIC METHODS
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

		var mainContent;
		var resultsScreen;
		var resultsEntry;
		var searchBox;
		var searchBtn;
		var searchTerm;

		// initalize the application
		search.init = function()
		{
			mainContent = document.querySelector("#main-content");
			resultsScreen = document.querySelector("#results-screen");
			resultsEntry = document.querySelector("#results-entry");
			searchBox = document.querySelector("#search-box");
			searchBtn = document.querySelector("#search-btn");
			searchTerm = document.querySelector("#search-term");

			message.init(); // initialize message box
			
			searchBtn.addEventListener( "mousedown" , searchBtnClicked , false );
			searchTerm.addEventListener( "focus" , searchTermFocus , false );
			searchTerm.addEventListener( "keyup" , returnPressed , false )

			$(mainContent).fadeIn();
		}

		// PRIVATE METHODS
		// search button was clicked
		function searchBtnClicked(evt)
		{
			if ( !searchBox.classList.contains("mini") )
			{
				searchBox.classList.remove( "large" );
				searchBox.classList.add( "hide" );
				searchBox.classList.add( "mini" );
				mainContent.classList.add( "mini" );
				mainContent.addEventListener("transitionend", mainMinified, true);
				resultsScreen.classList.remove("hide");
			}
			lookupData(main.getData(), searchTerm.value);
		}

		function mainMinified(evt)
		{
			searchBox.classList.remove("hide");
		}

		function returnPressed(evt)
		{
			// if enter key was pressed, submit the form
			if (evt.which == 13)
				searchBtnClicked();
		}

		function lookupData(data,query)
		{
			var entry = data["000"]["name"];
			if ( entry == query )
			{
				console.log("Query Successful!");
				resultsEntry.innerHTML = "Samaritan House";
			}
			else
			{
				resultsEntry.innerHTML = "Nothing Found!";
				message.display("Nothing matched your search! <br />Try another search term!");
			}
		}

		function searchTermFocus()
		{
			message.hide();
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
			messageBox.style.opacity = 0;
			this.show();
			messageBox.style.top = ((messageBox.offsetHeight - 16)*-1)+"px";
			messageArrow.style.top = (messageBox.offsetHeight - 7)+"px";
			messageBox.style.opacity = 1;
		}

		message.show = function()
		{
			messageBox.classList.remove("hide");
		}

		message.hide = function()
		{
			messageBox.classList.add("hide");
		}

		return message;
	})();

	//=================================================================================
	// Utility JS functions
	var util = (function(){
		var util = {};

		// get computed style (from http://stackoverflow.com/questions/2664045/how-to-retrieve-a-styles-value-in-javascript)
		util.getStyle = function(el, styleProp) {
		  var value, defaultView = (el.ownerDocument || document).defaultView;
		  // W3C standard way:
		  if (defaultView && defaultView.getComputedStyle) {
		    // sanitize property name to css notation
		    // (hypen separated words eg. font-Size)
		    styleProp = styleProp.replace(/([A-Z])/g, "-$1").toLowerCase();
		    return defaultView.getComputedStyle(el, null).getPropertyValue(styleProp);
		  } else if (el.currentStyle) { // IE
		    // sanitize property name to camelCase
		    styleProp = styleProp.replace(/\-(\w)/g, function(str, letter) {
		      return letter.toUpperCase();
		    });
		    value = el.currentStyle[styleProp];
		    // convert other units to pixels on IE
		    if (/^\d+(em|pt|%|ex)?$/i.test(value)) { 
		      return (function(value) {
		        var oldLeft = el.style.left, oldRsLeft = el.runtimeStyle.left;
		        el.runtimeStyle.left = el.currentStyle.left;
		        el.style.left = value || 0;
		        value = el.style.pixelLeft + "px";
		        el.style.left = oldLeft;
		        el.runtimeStyle.left = oldRsLeft;
		        return value;
		      })(value);
		    }
		    return value;
		  }
		}

		return util;
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