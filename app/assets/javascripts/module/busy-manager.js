define(function() {
  'use strict';
	
	// manages showing and hiding of splash screen
	var view;

	// init
	function init()
	{
		//console.log(fragment);
		view = document.getElementById("splash-screen");
		hide();
	}

	function show(message)
	{
		view.classList.remove('hide');
	}
	
	function hide()
	{
		view.classList.add('hide');
	}

	return {
		init:init,
		show:show,
		hide:hide
	};
});