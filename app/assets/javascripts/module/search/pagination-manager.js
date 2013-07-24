// handles ajax search functionality
define(['util/util'],
	function(util) {
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
				nextBtn.addEventListener("click", _linkClickedHandler, false);
				prevBtn.addEventListener("click", _linkClickedHandler, false);
			}			
		}

		function _linkClickedHandler(evt)
		{
			var params = util.getQueryParams(this.search);
			
			_callback.performSearch(params);

			evt.preventDefault();
			return false;
		}

	return {
		init:init,
		refresh:refresh
	};
});