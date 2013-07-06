require(['busy-manager',
				 'ajax-search',
				 'result-view-manager',
				 'domReady!'], 
	function(bm,as,rvm,mvm) {
  'use strict';

  // javascript goes here!
  bm.init();
  rvm.init();
  //  console.log("results screen loaded", bm,ism,am,som,pm,mvm,rvm,rsm,dm,as);
  console.log("results screen loaded", bm,as,rvm)
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