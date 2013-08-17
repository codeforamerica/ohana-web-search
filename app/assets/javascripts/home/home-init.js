// manages homepage scripts
require(['home/search-switcher','search/input-manager'],function(switcher,input) {
  'use strict';

  switcher.init(); // category search initialization
  input.init(); // input manager initialization

});