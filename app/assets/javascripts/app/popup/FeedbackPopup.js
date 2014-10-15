// Used for creating a popup that appears when the designated link is clicked.
define([
  'app/popup/DefaultPopup',
  'app/feedback-form-manager'
],
function (DefaultPopup, feedback) {
  'use strict';

  // Create a FeedbackPopup instance.
  // @return [Object] The FeedbackPopup instance.
  function create(link) {
    var popup = new FeedbackPopup().init(link);
    feedback.init();
    return popup;
  }

  function FeedbackPopup() {

    // Use composition to layer this type on the default.
    var _proxy;

    var instance = this;

    // Initialize the popup.
    // @return [Object] The FeedbackPopup instance.
    function init(link) {
      _proxy = DefaultPopup.create(link);
      return instance;
    }

    // Show the popup.
    // @return [Object] The FeedbackPopup instance.
    function toggle() {
      _proxy.toggle();
      return instance;
    }

    // Show the popup.
    // @return [Object] The FeedbackPopup instance.
    function show() {
      _proxy.show();
      return instance;
    }

    // Hide the popup.
    // @return [Object] The FeedbackPopup instance.
    function hide() {
      _proxy.hide();
      return instance;
    }

    // @param event [String] The event name to listen for.
    //   Supports 'show' and 'hide'.
    // @param callback [Function] The function called when the event has fired.
    // @return [Object] The FeedbackPopup instance.
    function addEventListener(event, callback) {
      _proxy.addEventListener(event, callback);
      return instance;
    }

    instance.init = init;
    instance.show = show;
    instance.hide = hide;
    instance.toggle = toggle;
    instance.addEventListener = addEventListener;

    return instance;
  }

  return {
    create:create
  };
});