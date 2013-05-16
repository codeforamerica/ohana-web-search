/* Application functionality */

var main = (function () {
"use strict";
	var main = {};

	// initalize the application
	main.init = function()
	{
		busyManager.init();
		busyManager.hide(); // temp - immediately hide
		infoScreenManager.init(); // initialize help/info screen (in utility bar)
		alertManager.init(); // intialize alert box manager
		searchOpManager.init(); // search options functionality
		distanceManager.init(); // intialize display of distances
	}

	//=================================================================================
	// manages show and hiding of splash screen
		var busyManager = (function(){
		var busyManager = {};

		var splashScreen; // loading screen

		// PUBLIC METHODS
		busyManager.init = function()
		{
			splashScreen = document.getElementById("splash-screen");
			//.success(function() { dataLoadedSuccess(); })
			//.error(function() { dataLoadedError(); })
			//.complete(function() { dataLoadedComplete(); });
		}

		// PUBLIC METHODS
		busyManager.show = function()
		{
			console.log("show splash screen");
			splashScreen.classList.remove("hide");
		}
		
		busyManager.hide = function()
		{
			console.log("hide splash screen");
			splashScreen.classList.add("hide");
		}
	
		return busyManager;
	})();

	//=================================================================================
	// manages show and hiding of info screen
	var infoScreenManager = (function(){
		var infoScreenManager = {};

		// PRIVATE PROPERTIES
		var infoScreenBtn; // help screen that covers content
		var infoScreen; // help screen that covers content

		// PUBLIC PROPERTIES
		infoScreenManager.storageName = "hrl-infoscreen";

		// PUBLIC METHODS
		infoScreenManager.init = function()
		{
			//console.log("initialized infoscreen");
			infoScreenBtn = document.getElementById("info-screen-btn");
			infoScreen = document.getElementById("info-screen");

			infoScreenBtn.addEventListener("mouseover",btnOverHandler,false);
			infoScreenBtn.addEventListener("mouseout",btnOutHandler,false);
			infoScreenBtn.addEventListener("mousedown",maximizeHandler,false);

			infoScreen.addEventListener("mousedown",minimizeHandler,false);

			if (webStorageProxy.getItem(infoScreenManager.storageName))
				infoScreenManager.minimize();
			else
				infoScreenManager.maximize();
		}

		// PUBLIC METHODS
		infoScreenManager.maximize = function()
		{
			// prevent mouseout of infoscreenbtn
			infoScreenBtn.removeEventListener("mouseout",btnOutHandler,false);

			// show info screen
			infoScreen.classList.remove("mini");
			infoScreen.classList.add("max");
		}
		
		infoScreenManager.minimize = function()
		{
			// hide info screen
			infoScreen.classList.add("mini");
			infoScreen.classList.remove("max");
			
			// enable mouseout of infoscreenbtn
			infoScreenBtn.addEventListener("mouseout",btnOutHandler,false);
			
			// record that the info screen has been seen
			webStorageProxy.setItem(infoScreenManager.storageName,true);
		}


		// PRIVATE METHODS
		// minimize the info/help box
		function minimizeHandler(evt)
		{
			if (evt.target.attributes["href"] == undefined)
			{
				infoScreenManager.minimize();
				// mouseout of button is cursor is not over the button
				if (infoScreenBtn != document.elementFromPoint(evt.clientX, evt.clientY) )
				{
					btnOutHandler();
				}
			}
		}

		// expand the info/help box
		function maximizeHandler(evt)
		{
			infoScreenManager.maximize();
		}

		// rollover handlers for the minified info/help box
		function btnOverHandler(evt)
		{
			infoScreenBtn.classList.add("over");
		}

		function btnOutHandler(evt)
		{
			infoScreenBtn.classList.remove("over");
		}

		return infoScreenManager;
	})();


	//=================================================================================
	// manages closing of alert box
	var alertManager = (function(){
		var alertManager = {};

		// PRIVATE PROPERTIES
		var messagesBox; // alert message box

		// PUBLIC METHODS
		alertManager.init = function()
		{
			messagesBox = document.getElementById("messages");

			messagesBox.addEventListener("mousedown", closeHandler, false)
		}

		// PRIVATE METHODS
		function closeHandler(evt)
		{
			// if clicked element has a close class, remove alert box content
			if (evt.target.classList.contains("close")) messagesBox.innerHTML = "";
		}

		return alertManager;
	})();


	//=================================================================================
	// manages search options
	var searchOpManager = (function(){
		var searchOpManager = {};

		// PUBLIC PROPERTIES
		searchOpManager.storageName = "hrl-searchop";

		// PRIVATE PROPERTIES
		var searchRadius; // search radius drop-down
		var insideContent; // #inside-content section
		var resultsList; // #results-list section
		var updateAlertBox; // #update-alert

		// PUBLIC METHODS
		searchOpManager.init = function()
		{
			searchRadius = document.getElementById("miles");
			if (searchRadius)
			{
				webStorageProxy.setItem(searchOpManager.storageName,searchRadius.value);
				searchRadius.addEventListener("change",changeHandler,false);
			}
		}

		function changeHandler(evt)
		{
			//webStorageProxy.setItem(searchOpManager.storageName,searchRadius.value);
			insideContent = document.getElementById("inside-content");
			resultsList = document.getElementById("results-list");
			updateAlertBox = document.getElementById("update-alert");
			if (!updateAlertBox)
			{
				updateAlertBox = document.createElement("section");
				updateAlertBox.id = "update-alert";
				updateAlertBox.innerHTML = "<button type='submit' form='search-form'>Update results!</button>";
				if (insideContent)
				{
					insideContent.appendChild(updateAlertBox);
					resultsList.style.opacity = 0.25;
				}
			}
		}

		return searchOpManager;
	})();


	//=================================================================================
	// manages appearance of distance in search results
	var distanceManager = (function(){
		var distanceManager = {};

		// PRIVATE PROPERTIES
		var distances; // array of distance

		// PUBLIC METHODS
		distanceManager.init = function()
		{
			distances = document.querySelectorAll("#results-list .distance");

			if (distances.length >0)
			{
				var totalDistance = webStorageProxy.getItem(searchOpManager.storageName);
				var totalWidth;
				var totalHeight;
				for(var d = 0;d<distances.length;d++)
				{
					var distanceBarBox = document.createElement("div");
						distanceBarBox.classList.add("distance-bar-box");
					var distanceBar = document.createElement("div");
						distanceBar.classList.add("distance-bar");
					var distanceLine = document.createElement("div");
						distanceLine.classList.add("distance-line");
					
					distances[d].appendChild(distanceBarBox);
					distanceBarBox.appendChild(distanceBar);
					distanceBarBox.appendChild(distanceLine);


					if (!totalWidth) totalWidth = distanceBarBox.offsetWidth;
					if (!totalHeight) totalHeight = distanceBarBox.offsetHeight;

					//console.log( totalWidth , distances[d].getAttribute("data-distance") , totalDistance );
					var travelDistance = (totalWidth*distances[d].getAttribute("data-distance"))/totalDistance;
					distanceBar.style.width = travelDistance+"px";
					distanceLine.style.width = travelDistance+"px";
				}
			}
		}

		return distanceManager;
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