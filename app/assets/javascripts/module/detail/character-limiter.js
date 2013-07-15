// manages limiting the characters of the description
// on the details page and providing a more/less link to 
// toggle showing or hiding excess text
define(function() {
  'use strict';

		// PRIVATE PROPERTIES
		var desc;
		var fulltext;
		var showChar = 400;
		var ellipsestext = "…";
		var moretext = "more";
    var lesstext = "less";

		// PUBLIC METHODS
		function init()
		{
			desc = document.querySelector("#detail-info .description");
			
			// if description exists
			if (desc) {
				fulltext = desc.innerHTML;
				
				if(fulltext.length > showChar) {
 					_showLess(null);
        }
			}
		}

		// show more text
		function _showMore(evt)
		{
			var target = evt.target;
			desc.innerHTML = fulltext;

			var lnk = document.createElement("a");
			lnk.innerHTML = lesstext;
       
      desc.appendChild(lnk);
      lnk.addEventListener("click", _showLess, false);

      return false;
		}
		
		// show less text
		function _showLess(evt)
		{
			fulltext = fulltext.trim();
      var c = fulltext.substr(0, showChar);
      var h = fulltext.substr(showChar-1, fulltext.length - showChar);
			
			if (h.length > 0)
			{
				var lnk = document.createElement("a");
				lnk.innerHTML = moretext;

	      var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span><span class="hide">' + h + '</span></span>';

	      desc.innerHTML = html;
	      desc.appendChild(lnk);
	      lnk.addEventListener("click", _showMore, false);
      }
		}

	return {
		init:init
	};
});