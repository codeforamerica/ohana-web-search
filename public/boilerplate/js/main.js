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

		var data; // loaded data
		var splashScreen; // loading data screen

		dataloader.init = function()
		{
			splashScreen = document.getElementById("splash-screen");
			
			var path = "/boilerplate/data/dbmock.json"; // load mock data
			$.getJSON(path, function(response){
			   data = response;
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
		dataloader.getData = function(index)
		{	
			if (index) return data[index];
			// currently the query does nothing, we just return the mock JSON object
			return data;
		}

		return dataloader;
	})();

	//=================================================================================
	// Search functionality - handles search queries
	var search = (function () {
		var search = {};

		var mainContent;
		var searchBox;
		var searchBtn;
		var searchTerm;

		// initalize the application
		search.init = function()
		{
			mainContent = document.querySelector("#main-content");
			searchBox = document.querySelector("#search-box");
			searchBtn = document.querySelector("#search-btn");
			searchTerm = document.querySelector("#search-term");

			//message.init(); // initialize message box
			
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
				results.init();
			}
			lookupData( dataloader.getData(), searchTerm.value );
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

		// looks up the query in the data source
		// this function is mock code for the most part to fit the mock data source currently being used
		function lookupData(data,query)
		{
			results.reset(); // clear results list

			// iterate through three items in dataset
			for (var d=0; d<3; d++)
			{
				if (data[d]["name"] == query)
				{
					//console.log("place");
					results.addEntry( data[d] , d );
				}
				else
				{
					for (var c=0; c< data[d]["category"].length; c++)
					{
						 if (data[d]["category"][c] == query)
						 {
						 	//console.log("category");
						 	results.addEntry( data[d] , d );
						 }
					}
				}
			}
		}

		function searchTermFocus()
		{
			message.hide();
		}
		
		return search;
	})();

	//=================================================================================
	// Results entry functionality
	var results = (function(){
		var results = {};

		var resultsScreen;
		var selectedEntry = null; // the selected item in the results list
		var entries = {};

		results.init = function()
		{
			resultsScreen = document.querySelector("#results-screen");		
			resultsScreen.classList.remove("hide");
			details.init(); // initialize details object
		}

		results.reset = function()
		{
			resultsScreen.innerHTML = "";
		}

		results.addEntry = function( data , index )
		{
			var entry = document.createElement("div");
			entry.classList.add('results-entry');
			entry.setAttribute("data-internalid", index);
			entry.innerHTML = data['name'];
			resultsScreen.appendChild(entry);

			entries[data['name']] = data;
			console.log(entries);

			if (data['type'] != ENTRY.ERROR)
			{
				entry.addEventListener( "mousedown" , entryDetailsClicked , false );
				entry.addEventListener( "mouseover" , entryDetailsOver , false );
				entry.addEventListener( "mouseout" , entryDetailsOut , false );
			}
		}

		// PRIVATE FUNCTIONS
		function entryDetailsClicked(evt)
		{
			var target = evt.toElement;
			if (selectedEntry != target)
			{
				if (selectedEntry) 
				{
						selectedEntry.classList.remove("results-entry-hover");
						selectedEntry.classList.remove("results-entry-selected");
						selectedEntry.addEventListener( "mousedown" , entryDetailsClicked , false );
				}
				selectedEntry = target;
				target.classList.add("results-entry-selected");
				target.removeEventListener( "mousedown" , entryDetailsClicked , false );

				details.show( dataloader.getData( target.getAttribute("data-internalid") ) );
			}
		}

		function entryDetailsOver(evt)
		{
			var target = evt.toElement;
			target.classList.add("results-entry-hover");
		}

		function entryDetailsOut(evt)
		{
			var target = evt.fromElement;
			if (target != selectedEntry)
			{
				target.classList.remove("results-entry-hover");
			}
		}

		return results;
	})();

	//=================================================================================
	// Details entry functionality
	var details = (function(){
		var details = {};

		var detailScreen;

		details.init = function()
		{
			detailScreen = document.querySelector("#detail-screen");
		}

		details.hide = function()
		{
			detailScreen.classList.add("hide");			
		}

		details.show = function(entry)
		{
			detailScreen.classList.remove("hide");
			detailScreen.innerHTML = '<h1 class="name">'+entry["name"]+'</h1>';
            detailScreen.innerHTML += '<p class="address">';
            detailScreen.innerHTML += '<div class="street">'+entry["address"]["street"]+'</div>';
            detailScreen.innerHTML += '<div class="city">'+entry["address"]["city"]+'</div>';
            detailScreen.innerHTML += '<div class="state">'+entry["address"]["state"]+'</div>';
            detailScreen.innerHTML += '<div class="zip">'+entry["address"]["zip"]+'</div>';
            detailScreen.innerHTML += '</p>';
            detailScreen.innerHTML += '<p class="phone">'+entry["phone"]+'</p>';
			console.log(entry);

		}

		return details;
	})();

	//=================================================================================
	// Entry types, used in results object when adding entrys 
	var ENTRY = {
		"ERROR":0,
		"CATEGORY":1,
		"PLACE":2
	};

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