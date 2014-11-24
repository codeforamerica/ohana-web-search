// Manages page appearance when Google Maps can't be loaded.
define([
  'app/alerts'
],
function (alerts) {
  'use strict';

  function init() {
    console.log('Map failed to load! Hiding map HTML code.');

    document.getElementById('detail-map-view').className = 'hide';

    var message = 'Oops! Map failed to load. Try reloading the page or ' +
                  '<a href="/about/#feedback-box">send us a message</a>.';
    alerts.show(message);
  }

  return {
    init:init
  };
});
