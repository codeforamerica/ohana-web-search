require(['result/result-map-manager'], function (map) {
  'use strict';

  map.init();

}, function (err) {
    //The errback, error callback
    //The error has a list of modules that failed
    var failedId = err.requireModules && err.requireModules[0];
    requirejs.undef(failedId);

    console.log("RequireJS threw an Error:",failedId,err.requireType);

    // initialize no map loaded state
    require(['result/no-result-map-manager'], function (map) {map.init();});
});
