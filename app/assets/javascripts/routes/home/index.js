require(['app/app-init', 'home/home-init',
         'domReady!'],
         function () {
  'use strict';
  // This class is added so the tests know the async scripts are loaded
  document.body.classList.add('require-loaded');
});
