// manages search initialization
define(['detail/detail-map-manager','detail/character-limiter','detail/term-popup-manager'],function(map,cl,tpm) {
  'use strict';

  function init()
  {
		map.init();
  	cl.init();
  	tpm.init();
  }

  init();

return {init:init}
});