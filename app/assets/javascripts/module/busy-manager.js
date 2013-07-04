define(function() {
  'use strict';
	
	// manages showing and hiding of busy screen
	var view;
	var main;

	// init
	function init()
	{
		//console.log(fragment);
		view = document.getElementById("busy-screen");
		main = document.getElementById("search-content");
		hide();
	}

	function show(message)
	{
		view.classList.remove('fade-out');
		view.classList.add('fade-in');

		main.classList.remove('fade-in-delay');
		main.classList.add('fade-out-delay');
	}
	
	function hide()
	{
		view.classList.remove('fade-in');
		view.classList.add('fade-out');

		main.classList.remove('fade-out-delay');
		main.classList.add('fade-in-delay');
	}

	return {
		init:init,
		show:show,
		hide:hide
	};
});