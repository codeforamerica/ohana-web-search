require(['loading-manager', 
	       'popup-manager',
				 'domReady!'], 
	function(lm,pm) {
  'use strict';

  // initialize required scripts
  lm.hide();
  pm.init();
});