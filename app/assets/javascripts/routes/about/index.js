require(['app/feedback-form-manager',
         'addEventListener',
         'classList',
         'domReady!'],
  function(feedback) {
  'use strict';

  document.body.classList.add("require-loaded");
  feedback.init();

});