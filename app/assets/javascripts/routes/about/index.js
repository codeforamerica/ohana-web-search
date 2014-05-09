require(['app/feedback-form-manager',
         'addEventListener',
         'classList',
         'domReady!'],
  function(feedback) {
  'use strict';

  // This class is added so the tests know the async scripts are loaded
  document.body.classList.add("require-loaded");
  feedback.init();

});