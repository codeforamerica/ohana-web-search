// manages showing and hiding of splash screen
var module = (function (module) {

	module.busyManager = (function (busyManager) {

		var splashScreen; // loading screen

		// PUBLIC METHODS
		busyManager.init = function()
		{
			splashScreen = document.getElementById("splash-screen");
			busyManager.hide();
			//.success(function() { dataLoadedSuccess(); })
			//.error(function() { dataLoadedError(); })
			//.complete(function() { dataLoadedComplete(); });
		}

		// PUBLIC METHODS
		busyManager.show = function()
		{
			//console.log("show splash screen");
			splashScreen.classList.remove("hide");
		}
		
		busyManager.hide = function()
		{
			//console.log("hide splash screen");
			splashScreen.classList.add("hide");
		}
	
		return busyManager;
	})({});

	return module;
})(module || {})