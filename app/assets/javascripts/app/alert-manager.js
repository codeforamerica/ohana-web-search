// manages behavior of popups
define(function() {
  'use strict';

		// PRIVATE PROPERTIES
		var _alert;
		var _content;
		var _closeBtn;

		// PUBLIC METHODS
		function init()
		{
			_alert = document.getElementById('alert-box');
			_content = document.getElementById('alert-message');
			_closeBtn = document.getElementById('alert-close');
			_closeBtn.addEventListener('click',_closeBtnClicked,false);
		}

		// PRIVATE METHODS

		function show(message)
		{
			if (!_alert) init();
			_alert.classList.remove('hide');
			_content.innerHTML = message;
		}

		function hide()
		{
			_alert.classList.add('hide');
			_content.innerHTML = '';
		}

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