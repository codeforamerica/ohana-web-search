require(['result/result-map-manager','search/header-manager'], function (map,header) {
  'use strict';

  map.init();
  header.init();

}, function (err) {
    //The error callback
    //The err object has a list of modules that failed
    var failedId = err.requireModules && err.requireModules[0];
    requirejs.undef(failedId);

    console.log("RequireJS threw an Error:",failedId,err.requireType,err);

    // initialize no map loaded state
    require(['result/no-result-map-manager','search/header-manager'], function (map,header) {
      map.init();
      header.init();
  });
});
