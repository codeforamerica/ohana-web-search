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
			//_offsetY = document.getElementById('content-header').offsetHeight;
			var doc = document.documentElement, body = document.body;
			_offsetY = util.getOffset(_header).top;
			_floatingContent = document.querySelector('#floating-results-header .floating-content');

			_checkIfFloating();

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
				// fix header
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