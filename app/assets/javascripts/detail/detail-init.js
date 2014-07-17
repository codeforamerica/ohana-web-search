require([
  'detail/detail-map-manager',
  'detail/character-limiter',
  'search/header-manager'
], function (map,cl,header) {
  'use strict';

  map.init();
  cl.init();
  header.init();

}, function (err) {
  'use strict';
  //The error callback.
  //The `err` object has a list of modules that failed.
  var failedId = err.requireModules && err.requireModules[0];
  requirejs.undef(failedId);

  console.log("RequireJS threw an Error:",failedId,err.requireType);

  // Initialize no map loaded state.
  require([
    'detail/no-detail-map-manager',
    'detail/character-limiter',
    'search/header-manager'
  ], function (map,cl,header) {
    map.init();
    cl.init();
    header.init();
  });
});
