// the result and details inits are full modules unlike the other section initializers
// because they need to have a method to re-initialize their functionality after an 
// ajax request updates part of the page.
define(['detail/character-limiter','detail/term-popup-manager'],function(cl,tpm) {
  'use strict';

  function init()
  {
		cl.init();
  	tpm.init();
  }
  
  init();

return {init:init}
});
