require(['result/result-map-manager','search/header-manager'], function (map,header) {
  'use strict';

  // The map module is self-executing because it requires two sequential non-AMD
  // modules that depend on each other (Google Maps and Google Maps Utilities Library).
  // Therefore, it needs to asynchronously load Google Maps and then load the
  // Map Utility Library, which means its init function's scope can't be
  // reached at this level of code, so the init function is set to automatically
  // execute after it is defined, within the module.
  // If the map module is refactored to allow calling of the init function
  // from this scope (to control execution order), then the following line
  // can be uncommented:
  //map.init();
  header.init();

}, function (err) {
  'use strict';
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
}
);
