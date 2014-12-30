// Manages behavior of feedback form.
define([
  'app/alerts',
  'util/util',
  'util/EventObserver',
  'jquery'
],
function (alerts, util, eventObserver, $) {
  'use strict';

  function create(selector) {
    return new FeedbackForm().init(selector);
  }

  function FeedbackForm() {
    var _instance = this;

    // The events this instance broadcasts.
    var _events = {
      SUCCESS: 'success',
      ERROR: 'error'
    };
    eventObserver.attach(this);

    var _sendBtn;

    var _commentInput;
    var _emailInput;

    // @param selector [String] The HTML DOM selector for the feedback form.
    // jshint validthis: true
    function init(selector) {
      var form = document.querySelector(selector);
      _sendBtn = form.querySelector('.button-feedback-send');
      _sendBtn.addEventListener('click', _sendBtnClicked, false);

      _commentInput = form.querySelector('.comment');
      _emailInput = form.querySelector('.email');

      if (util.isEventSupported('input')) {
        _commentInput.addEventListener('input', _onFeedbackFormInput);
        _emailInput.addEventListener('input', _onFeedbackFormInput);
      } else {
        _sendBtn.disabled = '';
      }
      return this;
    }

    function _sendBtnClicked(evt) {
      // Stop the form from submitting.
      evt.preventDefault();
      var emailCheck = new RegExp('.+@.+\..+','i');
      var match = emailCheck.exec(_emailInput.value);
      if (match || _emailInput.value === '')
        _feedbackFormSend();
      else
        _incorrectEmailAddress();
    }

    function _onFeedbackFormInput() {
      _updateFeedbackForm();
    }

    function _isFeedbackFormMessagePresent() {
      var message = _commentInput.value;
      message = message.trim();

      if (util.isEventSupported('input')) {
        return message.length > 0;
      } else {
        return true;
      }
    }

    function _updateFeedbackForm() {
      if (_isFeedbackFormMessagePresent()) {
        _sendBtn.disabled = false;
      } else {
        _sendBtn.disabled = true;
      }
    }

    function _feedbackFormSend()
    {
      var agent = '\nUser agent: ' + navigator.userAgent;

      var csrfToken = $('meta[name="csrf-token"]').attr('content');

      var transmission = {
        message: _commentInput.value,
        from: _emailInput.value,
        agent: agent
      };

      $.ajax({
          headers: {
            'X-CSRF-Token': csrfToken
          },
          url             : '/feedback',
          type            : 'POST',
          dataType        : 'json',
          data            : JSON.stringify(transmission),
          contentType     : 'application/json',
          success         : _onSuccess,
          error           : _onError
        });
    }

    // On successful submission of commment, clear out the input values,
    // display a success alert message, and broadcast a success event.
    function _onSuccess() {
      alerts.show('Feedback Sent! Thank you!', alerts.type.VALID);
      _commentInput.value = '';
      _updateFeedbackForm();
      _instance.dispatchEvent(_events.SUCCESS, {target:_instance});
    }

    // On unsuccessful submission of commment, clear out the input values
    // and display a failure alert message.
    function _onError() {
      var message = 'Error sending feedback, please ' +
                    '<a href="/">reload</a> and try again!';
      alerts.show(message, alerts.type.ERROR);
      _commentInput.value = '';
      _emailInput.value = '';
      _updateFeedbackForm();
      _instance.dispatchEvent(_events.ERROR, {target:_instance});
    }

    // Incorrect email address. Show error message.
    function _incorrectEmailAddress() {
      var message = 'Your email address appears to be formatted ' +
                    'incorrectly, please try again!';
      alerts.show(message, alerts.type.ERROR);
      _emailInput.value = '';
    }

    _instance.init = init;
    return _instance;
  }

  return {
    create:create
  };
});
