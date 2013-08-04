// manages search initialization
require(['app/loading-manager','app/popup-manager'],function(lm,pm) {
  'use strict';
  
  document.body.classList.add("require-loaded");

  lm.hide();
  pm.init();

});
