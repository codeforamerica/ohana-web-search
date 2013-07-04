define(function() {
  'use strict';
	
	// manages showing and hiding of busy screen
	var view;

	// init
	function init()
	{
		//console.log(fragment);
		view = document.getElementById("busy-screen");
		hide();
	}

	function show(message)
	{
		view.classList.remove('fade-out');
		view.classList.add('fade-in');
	}
	
	function hide()
	{
		view.classList.remove('fade-in');
		view.classList.add('fade-out');
	}

	return {
		init:init,
		show:show,
		hide:hide
	};
});