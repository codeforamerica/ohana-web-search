// manages search initialization
require(['app/loading-manager','app/popup-manager'],function(lm,pm) {
  'use strict';
  
  lm.hide();
  pm.init();

});
