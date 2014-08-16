// Manages search initialization.
require([
  'search/search-filter-manager',
  'search/input-manager'
],
function (filter, input) {
  'use strict';

  filter.init();
  input.init();
});
