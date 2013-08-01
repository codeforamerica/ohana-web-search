// handles creating a fixed search header when scrolling
define(['util/util'],
	function(util) {
  'use strict';
		
		var _header;
		var _offsetY;

		function init()
		{
			_header = document.getElementById("results-header");
			_offsetY = util.getOffset(_header);
			window.addEventListener("scroll",_onScroll,false);
		}

		function _onScroll(evt)
		{
			if (window.scrollY >= _offsetY.top)
			{
				// fix header
			}
			else
			{
				// reset header
			}
		}

	return {
		init:init
	};
});