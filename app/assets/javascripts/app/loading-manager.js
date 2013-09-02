// manages showing and hiding of busy screen
define(function() {
  'use strict';

	var _view = document.getElementById("loading-box");
	var _main = document.getElementById("content");
	var _fullscreen = true;

	function show(params)
	{
		_view.classList.remove('fade-out');
		_view.classList.add('fade-in');

		if (params && params.hasOwnProperty('fullscreen')) _fullscreen = params.fullscreen;

		if (_fullscreen)
		{
			_view.classList.add('fullscreen');
			_main.classList.remove('fade-in-delay');
			_main.classList.add('fade-out-delay');
		}
		else
		{
			_view.classList.remove('fullscreen');
		}
	}

	function hide()
	{
		_view.classList.remove('fade-in');
		_view.classList.add('fade-out');

		if (_fullscreen)
		{
			_main.classList.remove('fade-out-delay');
			_main.classList.add('fade-in-delay');
		}
	}

	return {
		show:show,
		hide:hide
	};
});