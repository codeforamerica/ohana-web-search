// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
  'app/google-analytics-manager',
  'jquery',
	'app/datalist-dropdown',
  'classList',
  'addEventListener',
  'Modernizr',
  'modernizrSelectors'],
  function (lm,pm,goog,ga,$,datalist) {
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

  ga.init(); // initalize google analytics
  lm.hide();
  // if box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();
  goog.init();

});