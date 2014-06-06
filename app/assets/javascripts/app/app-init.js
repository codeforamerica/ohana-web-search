// Manages the application initialization for most pages.
// This script is called by the homepage, search result
// and search details pages. It is not called by
// the about page, because that page does not have popups to manage.
require([
  'app/google-translate-manager',
  'app/popup-manager'
],
  function (gt, pm) {
  'use strict';

  // Initialize the google translate.
  gt.init();

  // if box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();
});