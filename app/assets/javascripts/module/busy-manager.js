define(function() {
  'use strict';
	
	// manages showing and hiding of splash screen
	var busyManager = {}
	var splashScreen;

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

	// init
	splashScreen = document.getElementById("splash-screen");
	busyManager.hide();
		
	return busyManager;
});