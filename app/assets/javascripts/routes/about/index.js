// Manages initialization of scripts for the About page.
require([
  'app/FeedbackForm',
  'application'
],
function (FeedbackForm) {
  'use strict';

  // Initialize the feedback form.
  FeedbackForm.create('#feedback-box .feedback-form');
});
