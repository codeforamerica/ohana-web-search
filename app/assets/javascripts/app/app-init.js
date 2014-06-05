// manages app initialization
require(['app/popup-manager',
  'app/google-translate-manager',
  'app/location-manager',
  'jquery',
  'classList',
  'addEventListener',
  'Modernizr',
  'modernizrSelectors'],

  function (pm,goog,location,$) {
  'use strict';

  document.body.classList.add("require-loaded");

  // Check if browser supports the :checked selector
  Modernizr.addTest('checkedselector',function(){
    return selectorSupported(':checked');
  });

  if (!Modernizr.checkedselector)
  {
    var radios = document.querySelectorAll("input[type=radio]");
    for(var r=0; r< radios.length; r++)
    {
      radios[r].style.visibility = "inherit";
    }
  }

  // if box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();
  goog.init();

  location.init();

});