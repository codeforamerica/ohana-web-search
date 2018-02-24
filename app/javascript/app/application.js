require([
  'util/translation/google-translate',
  'domReady!'
],
function (googleTranslate) {
  'use strict';

  // The google-translate script handles loading of the
  // Google Website Translator Gadget at the bottom of the page's body.
  // The layout settings passed in as an argument to the initialization
  // method can be set to:
  // InlineLayout.VERTICAL, InlineLayout.HORIZONTAL,
  // which correspond to the 'inline' display modes available through Google.
  // The 'tabbed' and 'auto' display modes are not supported.
  // The 'inline' InlineLayout.SIMPLE layout is also not supported.
  googleTranslate.init(googleTranslate.InlineLayout.VERTICAL);
});
