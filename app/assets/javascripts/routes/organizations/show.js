require(['loading-manager', 'popup-manager',
					'term-popup-manager',
				 'domReady!'], 
	function(bm,pm,tpm) {
  'use strict';

  // initialize required modules
  bm.init();
  pm.init();
  tpm.init();
});