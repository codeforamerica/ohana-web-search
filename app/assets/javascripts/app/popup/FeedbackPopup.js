// Used for creating a popup that appears when the designated link is clicked.
define([
  'app/popup/DefaultPopup',
  'app/feedback-form-manager'
],
function (DefaultPopup, feedback) {
  'use strict';

  // Create a FeedbackPopup instance. This instance extends the functionality
  // of the DefaultPopup object by initializing the feedback form also.
  // @return [Object] The FeedbackPopup instance.
  function create() {
    FeedbackPopup.prototype = DefaultPopup.create();
    return new FeedbackPopup();
  }

  function FeedbackPopup() {
    // Override the init function of the DefaultPopup instance to initialize
    // the feedback form after the popup initializes.
    this.init = function(link) {
      var instance = FeedbackPopup.prototype.init(link, this);
      feedback.init();
      return instance;
    };
    return this;
  }

  return {
    create:create
  };
});
