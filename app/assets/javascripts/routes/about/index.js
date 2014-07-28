// Manages initialization of scripts for the About page.
require([
  'app/google-translate-manager',
  'app/feedback-form-manager',
  'domReady!'
],
  function (gt, feedback) {
  'use strict';

  // This class is added so the tests know the async scripts are loaded.
  document.body.classList.add('require-loaded');

  // Initialize the Google Translate manager.
  gt.init();

  // Initialize the feedback form.
  feedback.init();
});
