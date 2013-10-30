// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
	'classList',
	'addEventListener',
	'app/datalist-dropdown'],function (lm,pm,goog,pfClassList,pfAddEventListener,datalist) {
  'use strict';

	document.body.classList.add("require-loaded");
  lm.hide();
  pm.init();
  goog.init();

  var inputs = document.querySelectorAll('input[list]');
  for (var i in inputs)
  {
  	datalist.init(inputs[i]);
  }

});