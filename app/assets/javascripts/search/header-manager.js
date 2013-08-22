// handles creating a fixed search header when scrolling
define(['util/util'],
	function(util) {
  'use strict';
		
		var _header;
		var _offsetY;
		var _floating = false;
		var _floatingContent;

		function init()
		{
			_header = document.getElementById("results-header");
			_offsetY = document.getElementById('content-header').offsetHeight;
			_floatingContent = document.querySelector('#results-header .floating-content');
			
			window.addEventListener("scroll",_onScroll,false);
		}

		function _onScroll(evt)
		{
			if (window.scrollY >= _offsetY)
			{
				// fix header
				if (!_floating)
				{
					_header.classList.add("floating");
					_floatingContent.classList.remove('hide');
					_floating = true;
				}
			}
			else
			{
				// reset header
				if (_floating)
				{
					_header.classList.remove("floating");
					_floatingContent.classList.add('hide');
					_floating = false;
				}
			}
		}

	return {
		init:init
	};
});