// manages behavior of popups
define(['util/util','app/feedback-form-manager'/*,'enquire'*/],function(util,feedback/*enquire*/) {
  'use strict';

		// PRIVATE PROPERTIES
		var _popups; // array of popups on the page

		// PUBLIC METHODS
		function init()
		{
			_addPopups();
			feedback.init();
		}


		// PRIVATE METHODS

		// adds hooks for triggering popups present on the page
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

		// removes popups and hooks
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

		// handler for when a popup link triggers a popup
		function _popupHandler(evt)
		{
			evt.preventDefault();

			var trigger = evt.target;
			var thisPopup = document.querySelector( trigger.hash );

			_show(thisPopup,trigger);
			window.addEventListener("resize", _resizeHandler, true);

			return false;
		}

		// handler for when the page is resized
		function _resizeHandler(evt)
		{
			_show(_lastPopup,_lastTrigger);
		}

		// show a popup
		// @param popup Reference to the popup HTML to show
		// @param trigger Reference to the link trigger HTML
		function _show(popup,trigger)
		{
			_lastTrigger = trigger;

			var container = popup.parentNode;
			var arrow = container.children[0];

			// get the window dimensions
			var winDim = util.getWindowRect();

			// find the position offset values of the link that triggered the popup
			var offset = util.getOffset(trigger);
			var offsetY = (offset.top+trigger.offsetHeight);
			var offsetX = (offset.left);

			// offset needed for CSS adjustments of rotating arrow inside a masking box
			// to move popup up/down, adjust the arrowOffset.top value, which will
			// cascade down to the popupOffset
			var arrowOffset = {'top':-6,'left':-14};
			var popupOffset = {'top':15+arrowOffset.top}

			// position the arrow relative to the triggering link
			arrow.style.top = (offsetY+arrowOffset.top)+"px";
			arrow.style.left = (offsetX+arrowOffset.left+(trigger.offsetWidth/2))+"px";

			// position the popup relative to the window
			popup.style.top = (offsetY+popupOffset.top)+"px";

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

		// handler for closing the popup
		function _closeHandler(evt)
		{
			var el = evt.target;
			if (el.attributes["href"] === undefined &&
				!el.classList.contains("popup-trigger") &&
				!el.parentNode.classList.contains("popup-container") &&
				el.nodeName !== 'TEXTAREA' &&
				el.nodeName !== 'INPUT' &&
				el.nodeName !== 'BUTTON'
				)
			{
				_closeLastPopup();
			}
		}

		// close the last opened popup
		function _closeLastPopup()
		{
			if (_lastPopup) _lastPopup.parentNode.classList.add("hide");
			document.getElementById("content").removeEventListener("mousedown", _closeHandler, true);
			window.removeEventListener("resize", _resizeHandler, true);
			feedback.hide();
		}

	return {
		init:init
	};
});