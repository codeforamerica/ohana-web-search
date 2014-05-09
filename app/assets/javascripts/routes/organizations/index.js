require(['app/app-init',
         'search/search-init',
         'result/result-init',
         'domReady!'],
  function (app,search,result) {
  'use strict';
  // This class is added so the tests know the async scripts are loaded
  document.body.classList.add("require-loaded");
});