// Manages initialization of scripts for the About page.
require([
  'app/feedback-form-manager',
  'application'
],
function (gt, feedback) {
  'use strict';

  // Initialize the feedback form.
  feedback.init();
});
