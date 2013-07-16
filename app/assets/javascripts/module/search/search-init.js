// manages search initialization
require(['search/ajax-search','search/search-op-manager','search/header-manager'],function(as,som,hm) {
  'use strict';

  as.init();
  som.init();
  hm.init();

});
