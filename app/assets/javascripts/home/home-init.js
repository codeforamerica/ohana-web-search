// manages homepage scripts
require(['home/category-search','search/input-manager'],function(category,input) {
  'use strict';

  category.init(); // category search initialization
  input.init(); // input manager initialization

});