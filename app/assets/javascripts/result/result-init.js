// the result and details inits are full modules unlike the other section initializers
// because they need to have a method to re-initialize their functionality after an
// ajax request updates part of the page.
define(['result/result-list-manager','result/result-map-manager'], function (results,map) {
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
  	results.init();
  }

return {init:init,refresh:refresh}
});
