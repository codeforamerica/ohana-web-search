require([
  'result/result-map',
  'search/header'
],
function (map, header) {
  'use strict';

  map.init();
  header.init();
},
function (err) {
  'use strict';
  //The error callback.
  //The err object has a list of modules that failed.
  var failedId = err.requireModules && err.requireModules[0];
  requirejs.undef(failedId);

  console.log('RequireJS threw an Error:', failedId, err.requireType, err);

  // Initialize no map loaded state.
  require(['result/no-result-map', 'search/header'],
    function (map, header) {

    map.init();
    header.init();

  });
});
