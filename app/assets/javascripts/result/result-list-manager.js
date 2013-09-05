// manages results maps view
define(function () {
  'use strict';

		// PUBLIC METHODS
		function init()
		{
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
			evt.stopPropagation();
			var el = evt.target;
			if (el.attributes["href"] === undefined)
			{
				//console.log(el);
				window.location = evt.currentTarget.getAttribute('data-href');
			}
		}

	return {
		init:init
	};
});
