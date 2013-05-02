/* Application functionality */

var main = (function () {
"use strict";
	var main = {};

	// initalize the application
	main.init = function()
	{
		console.log("Hi! main.js has successfully loaded!");
		busyManager.init(); // initialize splash screen manager
		busyManager.hide();
		infoScreen.init(); // initializae help screen
		
		//testSequence();
	}

	// temporary function for testing similating lag.
	function testSequence()
	{
		busyManager.show();
		var count = 0;
		var id = setInterval(run, 100);
		function run()
		{
			console.log("running",count);
			if (count++ >= 10)
			{
				clearInterval(id);
				busyManager.hide();
			}
		}
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
		var infoScreen = (function(){
		var infoScreen = {};

		// PRIVATE PROPERTIES
		var helpScreen; // help screen that covers content
		var infoBox; // info box on help screen

		var maxContent; // content in maximized info box
		var minContent; // content in minimized info box

		// PUBLIC PROPERTIES
		infoScreen.storageName = "hrl-infoscreen";

		// PUBLIC METHODS
		infoScreen.init = function()
		{
			//console.log("initialized infoscreen");
			helpScreen = document.getElementById("help-screen");
			infoBox = helpScreen.firstElementChild;

			maxContent = infoBox.innerHTML;
			minContent = "<h1>?</h1>";

			if (webStorageProxy.getItem(infoScreen.storageName))
			{
				infoScreen.minimize();
			}
			else
			{
				infoScreen.maximize();
			}
		}

		// PUBLIC METHODS
		infoScreen.maximize = function()
		{
			// setup minimize handlers
			helpScreen.removeEventListener("mousedown",maximizeHandler,false);

			helpScreen.classList.remove("hide");
			helpScreen.classList.remove("mini");
			helpScreen.classList.add("max");
			infoBox.innerHTML = maxContent;

			// remove rollover for the infobox
			infoBox.removeEventListener("mouseover",miniOverHandler,false);
			infoBox.removeEventListener("mouseout",miniOutHandler,false);
			
			helpScreen.addEventListener("mousedown",minimizeHandler,false);
		}
		
		infoScreen.minimize = function()
		{
			// style help screen, change content and set web storage
			helpScreen.classList.add("mini");
			helpScreen.classList.remove("max");
			infoBox.innerHTML = minContent;
			webStorageProxy.setItem(infoScreen.storageName,true)

			// add rollover for the infobox
			infoBox.addEventListener("mouseover",miniOverHandler,false);
			infoBox.addEventListener("mouseout",miniOutHandler,false);

			// setup maximize handlers
			helpScreen.addEventListener("mousedown",maximizeHandler,false);	

			miniOutHandler();
		}
		// PRIVATE METHODS
		// minimize the info/help box
		function minimizeHandler(evt)
		{
			infoScreen.minimize();
		}

		// expand the info/help box
		function maximizeHandler(evt)
		{
			infoScreen.maximize();
		}

		// rollover handlers for the minified info/help box
		function miniOverHandler(evt)
		{
			infoBox.classList.add("over");
		}

		function miniOutHandler(evt)
		{
			infoBox.classList.remove("over");
		}

		return infoScreen;
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