require(['app/loading-manager',
				 'app/feedback-form-manager',
				 'classList',
				 'domReady!'],
	function(lm,feedback,classList) {
  'use strict';

	document.body.classList.add("require-loaded");
  lm.hide();
  feedback.init();

});