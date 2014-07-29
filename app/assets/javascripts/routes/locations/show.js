require(['app/app-init',
         'search/search-init',
         'detail/detail-init',
         'domReady!'],
  function () {
  'use strict';
  // This class is added so the tests know the async scripts are loaded.
  document.body.classList.add('require-loaded');
});
