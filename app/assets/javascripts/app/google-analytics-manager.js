// Manages behavior of google analytics enabled links
define(function() {
  'use strict';

		// PUBLIC METHODS
    // If google analytics variable is initialized it will have a length
    // greater than 0. If this is the case look for elements on the page
    // that have the attribute "data-gaq" and add a click event listener
    // to these elements that register the element with google analytics.
		function init()
		{
      if (_gaq.length > 0)
      {
        var toTrack = document.querySelectorAll("*[data-gaq]");
        var item;
        for (var t=0; t<toTrack.length; t++)
        {
          item = toTrack[t];
          item.addEventListener("click", _track);
        }
      }
		}

    function _track(evt)
    {
      var item = evt.currentTarget;
      _gaq.push(item.getAttribute("data-gaq"));
    }

	return {
		init:init
	};
});