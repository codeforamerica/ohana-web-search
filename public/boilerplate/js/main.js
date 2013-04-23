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
		dataloader.getData = function(type,index)
		{	
			if (type && index) return data[type][index];
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

		search.setSearch = function(term)
		{
			searchTerm.value = term;
			searchBtnClicked();
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
				
				// initialize the categories and service provider lists
				categories.init();
				results.init();
			}
			categories.reset();
			results.reset();
			//details.reset();
				
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

			var categoryList = data["categories"]; // list of categories
			var providerList = data["providers"]; // list of providers

			/*
			// iterates through full subtree, to the end -- NOT USED!
			var queue = [],
		    	next = categoryList,
		    	current,
		    	inSubtree = false,
		    	count = 0;
		    while (next) {
		        if ("children" in next) {
		            for(var i=0;i<next["children"].length;i++){
		            	current = next["children"][i];
		            	if (inSubtree) 
		            		{
		            			queue.push( current );
		            			categories.addEntry( current , count++ );
		            		}
		            	if (current["name"].toLowerCase() == query.toLowerCase())
		    			{console.log( "found category match!" );
		    				inSubtree = true;
		    				queue.push( current );
		    				break;
		    			}
		            }
		        }
		        next = queue.shift();
		        console.log(next);
		    }
		    */

			// breadth-first search	to show category results.	    
		    var queue = [],
		    	next = categoryList,
		    	current,
		    	selectCategories = [],
		    	count = 0;
		    while (next) {
    	
		        if ("children" in next) {
		            for(var i=0;i<next["children"].length;i++){
		            	current = next["children"][i];

			            if (current["name"].toLowerCase() == query.toLowerCase())
		    			{
		    				selectCategories.push(current);
		    				
		    				if ("children" in current)
		    				{
			    				for (var e=0;e<current["children"].length;e++)
			    				{
			    					selectCategories.push(current["children"][e]);
			            			categories.addEntry( current["children"][e] , count++ );
			            		}
		            		}
		            		break;
		    			}
		            	queue.push( current );
		            }
		        }
		        next = queue.shift();
		    }


		    // perform a depth-first search to build the breadcrumb trail
		    var visited = {};
		    var crumbs = [];
		    var checkNew = false;
		    next = categoryList;
		    crumbs.push(categoryList);
		    while(crumbs.length != 0)
		    {
		    	checkNew = false;
		    	var t = crumbs[crumbs.length-1];
		    	if ("name" in t && t["name"].toLowerCase() == query.toLowerCase())
		    	{
		    		break;
		    	}
		    	
		    	if ("children" in t)
		    	{
			    	for (var e = 0; e < t["children"].length; e++)
			    	{
			    		var w = t["children"][e];
			    		if ("id" in w && !visited[w["id"]])
			    		{
			    			if ("id" in w) visited[w["id"]] = true;
			    			crumbs.push(w);
			    			checkNew = true;
			    			break;
			    		}
			    	}
		    	}
		    	if (!checkNew)
		    	{
		    		if ("id" in t) visited[t["id"]] = true;
		    		crumbs.pop();
		    	}
		    }
		    crumbs.shift(); // remove the first item, as it doesn't contain terms

		    categories.buildBreadCrumbs(crumbs);

		    
			// iterate through items in dataset
			var addedId = {};
			for (var d=0; d<4; d++)
			{
				if (data["providers"][d]["entry"]["name"].toLowerCase() == query.toLowerCase())
				{
					//console.log("place");
					results.addEntry( data["providers"][d]["entry"] , d );
				}
				else
				{
					if ("category" in data["providers"][d]["entry"])
					{
						for (var c=0; c< data["providers"][d]["entry"]["category"].length; c++)
						{
							for (var e=0;e<selectCategories.length;e++)
							{
								 if (data["providers"][d]["entry"]["category"][c] == selectCategories[e]["id"])
								 {
								 	//console.log("category");
								 	//console.log( data["providers"][d]["entry"] );
								 	if (!addedId[d]) results.addEntry( data["providers"][d]["entry"] , d );
								 	addedId[d] = true;
								 	break;
								 }
							}
						}
					}
				}
			}

			results.layoutResultsDetails(); // layout entry results details
		}

		function searchTermFocus()
		{
			//message.hide();
		}
		
		return search;
	})();

	//=================================================================================
	// Categories entry functionality
	var categories = (function(){
		var categories = {};

		var categoryScreen;
		var categoryScreenNav;
		var categoryList;
		var categories = {}; // object holding reference to all entry HTML

		categories.init = function()
		{
			categoryScreen = document.querySelector("#category-screen");
			categoryScreenNav= categoryScreen.firstElementChild.lastElementChild;
			categoryScreen.classList.remove("hide");
			categoryList = categoryScreen.lastElementChild;
			categories.init = null;
		}

		categories.reset = function()
		{
			categoryList.innerHTML = "";
		}

		categories.buildBreadCrumbs = function(list)
		{
			categories.resetBreadCrumb();
			var breadCrumb;
			for (var i = 0; i < list.length; i++)
			{
				breadCrumb = document.createElement("a");
				breadCrumb.setAttribute("title",list[i]["name"]);
				breadCrumb.innerHTML = list[i]["name"];
				if (i != (list.length-1)) 
				{
						breadCrumb.addEventListener( "mousedown" , entryDetailsClicked , false );
						breadCrumb.classList.add("breadcrumb");
				}
				else{ breadCrumb.classList.add("current-breadcrumb"); };
				categoryScreenNav.appendChild(breadCrumb);
			}
		}
		/*
		categories.addBreadCrumb = function(text)
		{
			var breadCrumb = document.createElement("a");
			breadCrumb.setAttribute("title",text);
			breadCrumb.innerHTML = text;
			categoryScreenNav.appendChild(breadCrumb);
			breadCrumb.addEventListener( "mousedown" , entryDetailsClicked , false );
		}
		*/

		categories.resetBreadCrumb = function()
		{
			categoryScreenNav.innerHTML = "";
		}

		// add an entry to the category results list
		categories.addEntry = function( data , catid , isSubCategory )
		{
			// add category section
			var entry = document.createElement("section");
			entry.classList.add('category-entry');
			entry.setAttribute("data-internalid", catid);
			entry.setAttribute("title", data['name']);
			entry.innerHTML = "<span class='category-title'>"+data['name']+"</span>";
			categoryList.appendChild(entry);

			//maxWidthOfResult = Math.max(entry.firstElementChild.offsetWidth,maxWidthOfResult); // increment maximum width

			categories[data['name']] = data;

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
			search.setSearch(target.title);

			/*
			if (selectedEntry != target)
			{
				if (selectedEntry) 
				{
						selectedEntry.classList.remove("category-entry-hover");
						selectedEntry.classList.remove("category-entry-selected");
						selectedEntry.addEventListener( "mousedown" , entryDetailsClicked , false );
				}
				selectedEntry = target;
				target.classList.add("category-entry-selected");
				target.removeEventListener( "mousedown" , entryDetailsClicked , false );

				details.show( dataloader.getData( "categories" , target.getAttribute("data-internalid") ) );
			}
			*/
		}

		function entryDetailsOver(evt)
		{
			var target = evt.toElement;
			target.classList.add("category-entry-hover");
		}

		function entryDetailsOut(evt)
		{
			var target = evt.fromElement;
			//if (target != selectedEntry)
				target.classList.remove("category-entry-hover");
		}

		return categories;
	})();

	//=================================================================================
	// Results entry functionality
	var results = (function(){
		var results = {};

		var resultsScreen;
		var resultsList;
		var selectedEntry = null; // the selected item in the results list
		var entries = {}; // object holding reference to all entry HTML
		var hourBoxes = [];
		var maxWidthOfResult = 0; // aggregate width of result entries, used to layout details

		results.init = function()
		{
			resultsScreen = document.querySelector("#results-screen");		
			resultsScreen.classList.remove("hide");
			resultsList = resultsScreen.lastElementChild;

			details.init(); // initialize details object
			results.init = null;
		}

		results.reset = function()
		{
			resultsList.innerHTML = "";
		}

		results.addEntry = function( data , id )
		{
			// add entry section
			var entry = document.createElement("section");
			entry.classList.add('results-entry');
			entry.setAttribute("data-internalid", id);
				entry.innerHTML = "<span class='entry-title'>"+data['name']+"</span>";
			resultsList.appendChild(entry);

			maxWidthOfResult = Math.max(entry.firstElementChild.offsetWidth,maxWidthOfResult); // increment maximum width

			// add opening times box to section
			var hourBox = document.createElement("span");
			hourBox.innerHTML = "<span class='hour-box'><span>OPEN</span> <span>till 5pm</span></span>";
			hourBoxes.push({"hourBox":hourBox,"titleWidth":entry.firstElementChild.offsetWidth}); // add hour box to array
			entry.appendChild(hourBox); // add hour box to entry

			entries[data['name']] = data;

			if (data['type'] != ENTRY.ERROR)
			{
				entry.addEventListener( "mousedown" , entryDetailsClicked , false );
				entry.addEventListener( "mouseover" , entryDetailsOver , false );
				entry.addEventListener( "mouseout" , entryDetailsOut , false );
			}
		}

		results.layoutResultsDetails = function()
		{
			for (var h in hourBoxes)
			{
				hourBoxes[h]["hourBox"].style.marginLeft = (maxWidthOfResult-hourBoxes[h]["titleWidth"])+"px";
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

				details.show( dataloader.getData( "providers" , target.getAttribute("data-internalid") ) );
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

			detailScreen.innerHTML = '<h1 class="name">'+entry["entry"]["name"]+'</h1>';
            detailScreen.innerHTML += '<p class="address">';
            detailScreen.innerHTML += '<div class="street">✉ '+entry["entry"]["address"]["street"]+'</div>';
            detailScreen.innerHTML += '<div class="city">'+entry["entry"]["address"]["city"]+'</div>';
            detailScreen.innerHTML += '<div class="state">'+entry["entry"]["address"]["state"]+'</div>';
            detailScreen.innerHTML += '<div class="zip">'+entry["entry"]["address"]["zip"]+'</div>';
            detailScreen.innerHTML += '</p>';
            detailScreen.innerHTML += '<p class="phone">☎ '+entry["entry"]["phone"]+'</p>';
            //detailScreen.innerHTML += '<p class="streetview"><img src="http://maps.googleapis.com/maps/api/streetview?size=320x240&location='+entry["location"]["lat"]+','+entry["location"]["lng"]+'&fov=80&heading='+entry["location"]["heading"]+'&pitch=10&sensor=false" /></p>';
            //detailScreen.innerHTML += '<p class="map"><img src="http://maps.googleapis.com/maps/api/staticmap?center='+entry["location"]["lat"]+','+entry["location"]["lng"]+'&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C'+entry["location"]["lat"]+','+entry["location"]["lng"]+'&sensor=false" /></p>';
			
			formatOpeningHours();
		}

		details.reset = function()
		{
			detailScreen.innerHTML = "";
		}

		// returns opening hours
		function formatOpeningHours()
		{
			var today = new Date(); // temp, needs to pull from data
			var openingTime = new Date(today);
			var weekDay = today.getDay();


			console.log( today , openingTime );
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