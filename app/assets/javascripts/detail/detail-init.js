require([
  'detail/detail-map',
  'detail/character-limited/character-limiter',
  'search/header',
  'detail/utility-links',
  'detail/term-popup-manager'
],
function (map, cl, header, utilityLinks, termPopups) {
  'use strict';

  map.init();
  cl.init();
  header.init();
  utilityLinks.init();
  termPopups.init();

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
    'detail/no-detail-map',
    'detail/character-limited/character-limiter',
    'search/header',
    'detail/utility-links',
    'detail/term-popup-manager'
  ],
  function (map, cl, header, utilityLinks, termPopups) {

    map.init();
    cl.init();
    header.init();
    utilityLinks.init();
    termPopups.init();

  });
});
