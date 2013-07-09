require(['loading-manager', 'popup-manager',
					'term-popup-manager','character-limiter',
				 'domReady!'], 
	function(bm,pm,tpm,cl) {
  'use strict';

  // initialize required modules
  bm.init();
  pm.init();
  tpm.init();
  cl.init();

});