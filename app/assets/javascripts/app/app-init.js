// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'classList',
	'addEventListener'],function(lm,pm,pfClassList,pfAddEventListener) {
  'use strict';
	
	document.body.classList.add("require-loaded");
  lm.hide();
  pm.init();

});