// manages search initialization
require(['app/loading-manager','app/popup-manager'],function(lm,pm) {
  'use strict';
	
	// try/catch wrap for IE error suppression
	try
	{  
	  document.body.classList.add("require-loaded");
  }catch(e){}

  lm.hide();
  pm.init();

});
