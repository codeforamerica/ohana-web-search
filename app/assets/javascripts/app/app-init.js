// manages app initialization
require(['app/popup-manager',
  'app/google-translate-manager',
  'app/google-analytics-manager',
  'jquery',
  'Modernizr',
  'modernizrSelectors',
  'classList',
  'addEventListener'
  ],

  function (pm,goog,ga,$,Modernizr) {
  'use strict';

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

  ga.init(); // initalize google analytics

  // if box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();
  goog.init();

});