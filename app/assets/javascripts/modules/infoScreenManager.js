// manages showing and hiding of splash screen
var module = (function (module) {

	module.infoScreenManager = (function (infoScreenManager) {
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

	return module;
})(module || {})