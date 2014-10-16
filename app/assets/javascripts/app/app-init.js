// Manages the application initialization for most pages.
// This script is called by the homepage, search result
// and search details pages. It is not called by
// the about page.
require([
  'util/translation/google-translate-manager',
  'app/popup/popup-manager',
  'app/alert-manager'
],
function (googleTranslate, popups, alert) {
  'use strict';

  // If page is not translated, initialize the header popups.
  if (!googleTranslate.isTranslated())
    popups.init();

  alert.init();
});
