// the result and details inits are full modules unlike the other section initializers
// because they need to have a method to re-initialize their functionality after an 
// ajax request updates part of the page.
define(function() {
  'use strict';

  function init()
  {
		// init any modules needed on the results list. Currently none are needed.
  }
  
  init();

return {init:init}
});
