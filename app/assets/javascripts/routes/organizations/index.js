require(['loading-manager', 
				 'popup-manager',
				 'ajax-search',
				 'result-view-manager',
				 'domReady!'], 
	function(lm,pm,as,rvm,mvm) {
  'use strict';

  // initialize required scripts
  lm.hide();
  pm.init();
  as.init();
  rvm.init();
});

/*
				 'info-screen-manager',
				 'alert-manager',
				 'search-op-manager',
				 'popup-manager',
				 'map-view-manager',
				 'result-sort-manager',
				 'distance-manager',
				 'ajax-search',
*/