// manages behavior of popups
define(['util'],function(util) {
  'use strict';

		// PRIVATE PROPERTIES
		var popups; // array of popups on the page
		var lastPopup; // the last popup to be shown
		var lastTrigger;

		// PUBLIC METHODS
		function init()
		{
			popups = document.querySelectorAll(".popup-trigger");

			var curr;
			for (var p=0; p < popups.length; p++)
			{
				curr = popups[p];
				curr.addEventListener("click", _popupHandler, false);
				curr.classList.add('active');
			}
		}

		
		// PRIVATE METHODS
		function _popupHandler(evt)
		{
			evt.preventDefault();

			var trigger = evt.target;
			var thisPopup = document.querySelector( trigger.hash );

			_show(thisPopup,trigger);

			window.addEventListener("resize", _resizeHandler, true);

			return false;
		}

		function _resizeHandler(evt)
		{
			_show(lastPopup,lastTrigger);
		}

		function _show(popup,trigger)
		{
			lastTrigger = trigger;

			var container = popup.parentNode;
			var arrow = container.children[0];

			// get the window dimensions
			var winDim = util.getWindowRect();
			
			var offset = util.getOffset(trigger);
			var offsetY = (offset.top+trigger.offsetHeight);
			var offsetX = (offset.left);

			arrow.style.top = (offsetY)+"px";
			arrow.style.left = (offsetX-10+(trigger.offsetWidth/2))+"px";

			popup.style.top = (offsetY+10)+"px";

			var cssWidth = util.getStyle(popup,"width");
			if ( (offsetX+Number(cssWidth.substring(0,cssWidth.length-2))) > winDim.width)
			{
				popup.style.right = "10px";
			}
			else
			{
				popup.style.left = (offsetX)+"px";
			}

			if (lastPopup && lastPopup != popup) lastPopup.parentNode.classList.add("hide");
			lastPopup = popup;
			lastPopup.parentNode.classList.toggle("hide");

			// set height to default in order to check against window height effectively
			popup.style.height = "auto"; 
			if (offsetY+popup.offsetHeight > winDim.height)
			{
				popup.style.height = (winDim.height-offsetY-20)+"px";
			}
			else
			{
				popup.style.height = "auto";
			}

			popup.style.zIndex = "9999";
			arrow.style.zIndex = "10000";

			// attach to content element, as document directly doesn't work correctly on Mobile Safari
			document.getElementById("content").addEventListener("mousedown", _closeHandler, true);
		}

		function _closeHandler(evt)
		{
			if (evt.target.attributes["href"] == undefined && 
				!evt.target.classList.contains("popup-trigger") && 
				!evt.target.parentNode.classList.contains("popup-container"))
			{
				lastPopup.parentNode.classList.add("hide");
				document.getElementById("content").removeEventListener("mousedown", _closeHandler, true);
			}
		}

	return {
		init:init
	};
});