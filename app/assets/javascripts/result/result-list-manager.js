// manages results maps view
define(function () {
  'use strict';

  	var _callback;

		// PUBLIC METHODS
		function init(callback)
		{
			_callback = callback;
			var lnks = document.querySelectorAll('#list-view li');
			var curr;
			for (var l=0; l < lnks.length; l++)
			{
				curr = lnks[l];
				curr.addEventListener("click", _linkClickedHandler, true);
			}
		}

		function _linkClickedHandler(evt)
		{
			var el = evt.target;
			if (el.attributes["href"] === undefined)
			{
				_callback.performSearchWithURL(evt.currentTarget.getAttribute('data-href'));
			}
			else if (el.attributes["href"])
			{
				_callback.performSearchWithURL(el.href);
			}

			evt.preventDefault();
			return false;
		}

	return {
		init:init
	};
});
