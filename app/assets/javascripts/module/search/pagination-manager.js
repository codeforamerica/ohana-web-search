// handles ajax search functionality
define(
	function() {
  'use strict';

  	var _callback; // target function to run when pagination buttons are clicked
  	
  	// @param target [Function] function to execute when pagination buttons are clicked
		function init(callback)
		{
			_callback = callback;
			refresh();
		}
		
		function refresh()
		{
			var nextBtn = document.querySelector('.pagination.next');
			var prevBtn = document.querySelector('.pagination.prev');

			if (nextBtn && prevBtn)
			{
				nextBtn.addEventListener("click", _callback, false);
				prevBtn.addEventListener("click", _callback, false);
			}			
		}

	return {
		init:init,
		refresh:refresh
	};
});