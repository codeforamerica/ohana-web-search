require(['app/app-init',
				 'search/search-init',
				 'result-view-manager',
				 'domReady!'], 
	function(app,search,rvm) {
  'use strict';

  // initialize required scripts
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