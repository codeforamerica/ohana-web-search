// Manages behavior of feedback form.
import alerts from 'app/alerts';
import util from 'app/util/util';
import eventObserver from 'app/util/EventObserver';

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

  function isFeedbackFormMessagePresent() {
    let message = _commentInput.value;
    message = message.trim();

    if (util.isEventSupported('input')) {
      return message.length > 0;
    }

    return true;
  }

  function updateFeedbackForm() {
    if (isFeedbackFormMessagePresent()) {
      _sendBtn.disabled = false;
    } else {
      _sendBtn.disabled = true;
    }
  }

  // On successful submission of commment, clear out the input values,
  // display a success alert message, and broadcast a success event.
  function onSuccess() {
    alerts.show('Feedback Sent! Thank you!', alerts.type.VALID);
    _commentInput.value = '';
    updateFeedbackForm();
    _instance.dispatchEvent(_events.SUCCESS, { target: _instance });
  }

  // On unsuccessful submission of commment, clear out the input values
  // and display a failure alert message.
  function onError() {
    const message = 'Error sending feedback, please ' +
                    '<a href="/">reload</a> and try again!';
    alerts.show(message, alerts.type.ERROR);
    _commentInput.value = '';
    _emailInput.value = '';
    updateFeedbackForm();
    _instance.dispatchEvent(_events.ERROR, { target: _instance });
  }

  function feedbackFormSend() {
    const agent = navigator.userAgent;

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const transmission = {
      message: _commentInput.value,
      from: _emailInput.value,
      agent,
    };

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/feedback');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', csrfToken);
    xhr.onload = function() {
      if (xhr.status === 200) {
        onSuccess();
      } else {
        onError();
      }
    };
    xhr.send(JSON.stringify(transmission));
  }

  // Incorrect email address. Show error message.
  function incorrectEmailAddress() {
    const message = 'Your email address appears to be formatted ' +
                  'incorrectly, please try again!';
    alerts.show(message, alerts.type.ERROR);
    _emailInput.value = '';
  }

  function sendBtnClicked(evt) {
    // Stop the form from submitting.
    const emailCheck = new RegExp(/.+@.+\..+/, 'i');
    const match = emailCheck.exec(_emailInput.value);
    evt.preventDefault();
    if (match || _emailInput.value === '') {
      feedbackFormSend();
    } else {
      incorrectEmailAddress();
    }
  }

  function onFeedbackFormInput() {
    updateFeedbackForm();
  }

  // @param selector [String] The HTML DOM selector for the feedback form.
  function init(selector) {
    const form = document.querySelector(selector);
    _sendBtn = form.querySelector('.button-feedback-send');
    _sendBtn.disabled = true;
    _sendBtn.addEventListener('click', sendBtnClicked, false);

    _commentInput = form.querySelector('.comment');
    _emailInput = form.querySelector('.email');

    if (util.isEventSupported('input')) {
      _commentInput.addEventListener('input', onFeedbackFormInput);
      _emailInput.addEventListener('input', onFeedbackFormInput);
    } else {
      _sendBtn.disabled = '';
    }
    return this;
  }

  _instance.init = init;
  return _instance;
}

export default {
  create:create
};
