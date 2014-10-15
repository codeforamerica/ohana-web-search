require([
  'detail/detail-map-manager',
  'detail/character-limited/character-limiter',
  'search/header-manager',
  'detail/utility-links-manager'
],
function (map, cl, header, utilityLinks) {
  'use strict';

  map.init();
  cl.init();
  header.init();
  utilityLinks.init();

},
function (err) {
  'use strict';
  //The error callback.
  //The `err` object has a list of modules that failed.
  var failedId = err.requireModules && err.requireModules[0];
  requirejs.undef(failedId);

  console.log('RequireJS threw an Error:', failedId, err.requireType);

  // Initialize no map loaded state.
  require([
    'detail/no-detail-map-manager',
    'detail/character-limited/character-limiter',
    'search/header-manager',
    'detail/utility-links-manager'
  ],
  function (map, cl, header, utilityLinks) {

    map.init();
    cl.init();
    header.init();
    utilityLinks.init();

  });
});
