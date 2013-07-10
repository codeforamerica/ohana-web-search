require(['loading-manager', 
				 'popup-manager',
				 'ajax-search',
				 'term-popup-manager',
				 'character-limiter',
				 'domReady!'], 
	function(lm,as,pm,tpm,cl) {
  'use strict';

  // initialize required modules
  lm.hide();
  as.init();
  pm.init();
  tpm.init();
  cl.init();

});