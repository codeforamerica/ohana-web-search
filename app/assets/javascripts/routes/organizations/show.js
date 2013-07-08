require(['loading-manager',
					'popup-manager',
				 'domReady!'], 
	function(bm,pum) {
  'use strict';

  // initialize required modules
  bm.init();
  pum.init();

    console.log("Show screen loaded", bm);
  
});