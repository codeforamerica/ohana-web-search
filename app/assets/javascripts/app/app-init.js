// manages search initialization
require(['classList','app/loading-manager','app/popup-manager'],function(polyfill,lm,pm) {
  'use strict';
	 
	document.body.classList.add("require-loaded");

  lm.hide();
  pm.init();

});
