// manages behavior of popups
var module = (function (module) {

	module.popupManager = (function (popupManager) {

		// PRIVATE PROPERTIES
		var popups; // array of popups on the page
		var lastPopup; // the last popup to be shown

		// PUBLIC METHODS
		popupManager.init = function()
		{
			popups = document.querySelectorAll(".popup-container");

			for (var p=0; p < popups.length; p++)
			{
				var popup = popups[p].firstElementChild;
				var term = popups[p].lastElementChild;
				popup.classList.add("hide");
				term.addEventListener("mousedown", popupHandler, false);
			}
		}

		// PRIVATE METHODS
		function popupHandler(evt)
		{
			var thisPopup = (evt.target).parentElement.firstElementChild;
			if (lastPopup && lastPopup != thisPopup) lastPopup.classList.add("hide");
			lastPopup = thisPopup;
			lastPopup.classList.toggle("hide");
			lastPopup.style.top = (lastPopup.offsetHeight*-1)+"px";
			document.addEventListener("mousedown", closeHandler, true);
		}

		function closeHandler(evt)
		{
			if (evt.target.attributes["href"] == undefined && !evt.target.classList.contains("popup-term"))
			{	
				lastPopup.classList.add("hide");
				document.removeEventListener("mousedown", closeHandler, true);
			}
		}

		return popupManager;
	})({});

	return module;
})(module || {})