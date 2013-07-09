require(['loading-manager', 'popup-manager',
				 'ajax-search',
				 'result-view-manager',
				 'domReady!'], 
	function(bm,pm,as,rvm,mvm) {
  'use strict';

  // initialize required scripts
  bm.init();
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