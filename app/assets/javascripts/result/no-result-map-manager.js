// manages page appearance when Google Maps can't be loaded
define(['app/alert-manager'],function (alert) {
  'use strict';

  // PUBLIC METHODS
  function init()
  {
    console.log("Map failed to load! Hiding map HTML code.");

    document.getElementById('map-view').className = 'hide';
    document.getElementById('map-view-control').className = 'hide';

    alert.show("Oops! Map failed to load. Try reloading the page or <a href='/about/#feedback-box'>send us a message</a>.");
  }

  return {
    init:init
  };
});
