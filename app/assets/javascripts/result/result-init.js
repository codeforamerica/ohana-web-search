// the result and details inits are full modules unlike the other section initializers
// because they need to have a method to re-initialize their functionality after an 
// ajax request updates part of the page.
define(['result/result-view-manager'],function(rvm) {
  'use strict';

  function init()
  {
		rvm.init();
  }
  
  init();

return {init:init}
});
