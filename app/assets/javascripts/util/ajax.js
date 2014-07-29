// handles ajax functionality
define([
  'jquery'
],
function ($) {
  'use strict';

  function request(query, callback) {
    if (callback) {
      $.ajax({
        beforeSend: function (request)
        {
          request.setRequestHeader('Accept', 'application/json');
        },
        cache: true,
        url: query
      }).done(callback.done).fail(callback.fail);
    } else {
      $.ajax({
        beforeSend: function (request)
        {
          request.setRequestHeader('Accept', 'application/json');
        },
        cache: true,
        url: query
      }).done(_success).fail(_failure);
    }
  }

  // default callbacks
  function _success(evt) {
    console.log('success', evt);
  }

  function _failure(evt) {
    console.log('error', evt);
  }

  return {
    request:request
  };
});