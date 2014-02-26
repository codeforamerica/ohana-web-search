// Manages behavior of alert popups
// The alert messages appear as a bar at the top of the screen when
// unexpected events occur, such as when geolocation could not determine
// the location of the user.
define(function() {
  'use strict';

		// PRIVATE PROPERTIES
		var _alert; // DOM element for the alert container
		var _content; // DOM element for the alert's content
		var _closeBtn; // DOM element for the alert's close button

		// PUBLIC METHODS
		function init()
		{
			_alert = document.querySelector('#alert-box');
			_content = _alert.querySelector('.alert-message');
			_closeBtn = _alert.querySelector('.alert-close');
			_closeBtn.addEventListener('click',_closeBtnClicked,false);
		}

		// PRIVATE METHODS
		function show(message)
		{
			if (!_alert) init(); // lazy initialization
			_alert.classList.remove('hide');
			_content.innerHTML = message;
		}

		// Hiding the alert box clears its content and hides it using CSS
		function hide()
		{
			_alert.classList.add('hide');
			_content.innerHTML = '';
		}

		// Closing the alert box hides the HTML
		function _closeBtnClicked(evt)
		{
			hide();
		}

	return {
		init:init,
		show:show,
		hide:hide
	};
});