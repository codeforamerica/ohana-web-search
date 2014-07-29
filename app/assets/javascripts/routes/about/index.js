// Manages initialization of scripts for the About page.
require([
  'app/google-translate-manager',
  'app/feedback-form-manager',
  'application'
],
function (gt, feedback) {
  'use strict';

  // Initialize the Google Translate manager.
  gt.init();

  // Initialize the feedback form.
  feedback.init();
});
