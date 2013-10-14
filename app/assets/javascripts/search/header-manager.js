// handles creating a fixed search header when scrolling
define(['util/util'],
	function(util) {
  'use strict';

		var _header;
		var _offsetY;
		var _floatingContent;

		function init()
		{
			_header = document.getElementById("floating-results-header");
			if(_header)
			{
				_offsetY = util.getOffset(_header).top;
				_floatingContent = document.querySelector('#floating-results-header .floating-content');

				_checkIfFloating();

				// If window has a hash, offset the scrolling by the height of the floating header.
				// Also offset scrolling if search container is above search results (it's not floated)
				if(window.location.hash )
				{
					var scrollOffset = _header.offsetHeight;
					window.scrollTo(0,(window.scrollY-scrollOffset));
				}
				else if( (util.getStyle(document.getElementById('search-container'),"float") == "none") )
				{
					var scrollOffset = util.getOffset(document.getElementById("persistent-results-header")).top;
					window.scrollTo(0,scrollOffset-1);
				}

				window.addEventListener("scroll",_onScroll,false);
			}
		}

		function _onScroll(evt)
		{
			_checkIfFloating();
		}

		function _checkIfFloating()
		{
			if (window.scrollY >= _offsetY)
			{
				// floating header
				_header.classList.add("floating");
				_floatingContent.classList.remove('hide');
			}
			else
			{
				// reset header
				_header.classList.remove("floating");
				_floatingContent.classList.add('hide');
			}
		}

	return {
		init:init
	};
});