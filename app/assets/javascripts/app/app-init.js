// Manages the application initialization for most pages.
// This script is called by the homepage, search result
// and search details pages. It is not called by
// the about page, because that page does not have popups to manage.
require([
  'app/popup-manager',
  'app/alert-manager'
],
function (pm, alert) {
  'use strict';

  // If box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();

  alert.init();
});
