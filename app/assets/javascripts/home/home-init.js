// manages homepage scripts
require(['home/location-manager','search/input-manager'],function(location,input) {
  'use strict';

  location.init();
  input.init(); // input manager initialization

});