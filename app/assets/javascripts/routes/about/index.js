require([
  'app/google-analytics-manager',
  'app/google-translate-manager',
  'app/feedback-form-manager',
  'domReady!'
],
  function(ga,gt,feedback) {
  'use strict';

  // This class is added so the tests know the async scripts are loaded.
  document.body.classList.add("require-loaded");

  // Initalize google analytics.
  ga.init();

  // Initialize the google translate.
  gt.init();

  // Initialize the feedback form.
  feedback.init();

});