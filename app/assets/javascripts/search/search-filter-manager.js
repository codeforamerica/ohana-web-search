// handles search filter toggle functionality
define(
	function() {
  'use strict';

  	var DISABLED = 0;
  	var ENABLED = 1;
  	var SOLE_ENABLED = 2;

		function init()
		{
			var toggles = document.querySelectorAll('#search-box .search-check');
			for (var t = 0; t < toggles.length; t++)
			{
				toggles[t].addEventListener('mousedown',_toggleClicked,true);
			}
		}

		function _toggleClicked(evt)
		{
			var toggle = (evt.currentTarget).childNodes[1]; // retrieve first child element

			var offset = (toggle.getAttribute('data-toggle-state')*20) || 0;
			var quadrant = evt.offsetX + offset;

			console.log( quadrant , offset );
			// quadrant 3
			if (quadrant > 40)
			{
				toggle.indeterminate = true;
				toggle.checked = false;
				//console.log("toggle SOLE_ENABLED");
				toggle.setAttribute('data-toggle-state', SOLE_ENABLED);
			}
			// quadrant 2
			else if (quadrant > 20)
			{
				toggle.indeterminate = false;
				toggle.checked = true;
				//console.log("toggle ENABLED");
				toggle.setAttribute('data-toggle-state', ENABLED);
			}
			// quadrant 1
			else
			{
				toggle.indeterminate = false;
				toggle.checked = false;
				//console.log("toggle DISABLED");
				toggle.setAttribute('data-toggle-state', DISABLED);
			}
			evt.preventDefault();
			evt.stopPropagation();
			return false;
		}

	return {
		init:init
	};
});