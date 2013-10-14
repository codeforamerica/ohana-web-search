// handles search filter toggle functionality
define(
	function() {
  'use strict';

		function init()
		{
			var toggles = document.querySelectorAll('#search-box .search-check');
			for (var t = 0; t < toggles.length; t++)
			{
				toggles[t].addEventListener('mousedown',_toggleClicked,false);
			}
		}

		// Makes the full width of the toggle clickable, not just the label.
		function _toggleClicked(evt)
		{
			if (evt.currentTarget == evt.target)
			{
				var toggle = (evt.currentTarget).childNodes[1]; // retrieve first child element
				toggle.checked = !toggle.checked;
			}
			evt.preventDefault();
			evt.stopPropagation();
			return false;
		}

	return {
		init:init
	};
});