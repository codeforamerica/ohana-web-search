require(['detail/detail-map-manager','detail/character-limiter','detail/term-popup-manager'],function (map,cl,tpm) {
  'use strict';

  map.init();
  cl.init();
  tpm.init();

}, function (err) {
    //The errback, error callback
    //The error has a list of modules that failed
    var failedId = err.requireModules && err.requireModules[0];
    requirejs.undef(failedId);

    console.log("RequireJS threw an Error:",failedId,err.requireType);

    // initialize no map loaded state
    require(['detail/no-detail-map-manager','detail/character-limiter','detail/term-popup-manager'], function (map,cl,tpm) {
 			map.init();
  		cl.init();
  		tpm.init();
  	});
});
