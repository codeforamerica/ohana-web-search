// manages behavior of popups
define(['util/util','enquire'],function(util,enquire) {
  'use strict';

		// PRIVATE PROPERTIES
		var _popups; // array of popups on the page
		var _lastPopup; // the last popup to be shown
		var _lastTrigger;

		// PUBLIC METHODS
		function init()
		{
			_addPopups();
			window.enquire.register("screen and (max-width: 767px)", {
			    match 	: _removePopups,  
			    unmatch : _addPopups
			});
		}

		
		// PRIVATE METHODS
		function _addPopups()
		{
			_popups = document.querySelectorAll(".popup-trigger");

			var curr;
			for (var p=0; p < _popups.length; p++)
			{
				curr = _popups[p];
				curr.addEventListener("click", _popupHandler, false);
				curr.classList.add('active');
			}
		}

		function _removePopups()
		{
			_closeLastPopup();
			_lastPopup = null;
			_lastTrigger = null;
			_popups = document.querySelectorAll(".popup-trigger");

			var curr;
			for (var p=0; p < _popups.length; p++)
			{
				curr = _popups[p];
				curr.removeEventListener("click", _popupHandler, false);
				curr.classList.remove('active');
			}
		}

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
			_show(_lastPopup,_lastTrigger);
		}

		function _show(popup,trigger)
		{
			_lastTrigger = trigger;

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

			if (_lastPopup && _lastPopup != popup) _lastPopup.parentNode.classList.add("hide");
			_lastPopup = popup;
			_lastPopup.parentNode.classList.toggle("hide");

			// set height to default in order to check against window height effectively
			popup.style.height = "auto";
			var padding = 20; // padding set on article > div
			if ( (offsetY+popup.offsetHeight+padding) > winDim.height)
			{
				popup.style.height = (winDim.height-offsetY-padding)+"px";
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
				_closeLastPopup();
			}
		}

		function _closeLastPopup()
		{
			_lastPopup.parentNode.classList.add("hide");
			document.getElementById("content").removeEventListener("mousedown", _closeHandler, true);
			window.removeEventListener("resize", _resizeHandler, true);
		}

	return {
		init:init
	};
});