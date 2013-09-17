// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'classList',
	'addEventListener',"app/google-translate-manager"],function (lm,pm,pfClassList,pfAddEventListener,goog) {
  'use strict';

	document.body.classList.add("require-loaded");
  lm.hide();
  pm.init();
  goog.init();

});