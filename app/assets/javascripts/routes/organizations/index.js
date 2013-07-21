require(['app/app-init',
				 'search/search-init',
				 'result/result-init',
				 'domReady!'], 
	function(app,search,rvm) {
  'use strict';

  // initialize required scripts
  rvm.init();
});