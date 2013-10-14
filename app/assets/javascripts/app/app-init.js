// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
	'classList',
	'addEventListener'],function (lm,pm,goog,pfClassList,pfAddEventListener) {
  'use strict';

	document.body.classList.add("require-loaded");
  lm.hide();
  pm.init();
  goog.init();

});