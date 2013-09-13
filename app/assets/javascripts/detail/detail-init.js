// the result and details inits are full modules unlike the other section initializers
// because they need to have a method to re-initialize their functionality after an
// ajax request updates part of the page.
define(['detail/detail-map-manager','detail/character-limiter','detail/term-popup-manager'],function (map,cl,tpm) {
  'use strict';

  var _callback; // store callback used to hand to map for searches

  function init(callback)
  {
  	_callback = callback;
  	refresh();
  }

  function refresh()
  {
  	map.init(_callback);
  	cl.init();
  	tpm.init();
  }

return {init:init,refresh:refresh};
});