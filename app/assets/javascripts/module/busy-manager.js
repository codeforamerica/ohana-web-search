define(function() {
  'use strict';
	
	// manages showing and hiding of splash screen
	var view;
	var animationFrame;

	// init
	function init()
	{
		//console.log(fragment);
		view = document.getElementById("splash-screen");
		view.firstElementChild.innerHTML = "Loading";
		hide();
	}

	function show(message)
	{
		view.classList.remove('fade-out');
		view.classList.add('fade-in');
		_animate();
	}
	
	function hide()
	{
		view.classList.remove('fade-in');
		view.classList.add('fade-out');
		_stop_animate();
	}

	function _animate()
	{
		animationFrame = setInterval(_animate_callback, 200);
	}

	function _stop_animate()
	{
		clearInterval(animationFrame);
	}

	function _animate_callback()
	{
		console.log("_animate_callback");
		//animationFrame = util.requestAnimationFrame()(_animate_callback);
		var val = view.firstElementChild.innerHTML;
		val += ".";
		if (val.indexOf("....") != -1) val = val.substring(0,val.length-4)
		view.firstElementChild.innerHTML = val;
	}



	return {
		init:init,
		show:show,
		hide:hide
	};
});