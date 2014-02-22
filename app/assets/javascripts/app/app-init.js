// manages app initialization
require(['app/popup-manager',
	'app/google-translate-manager',
  'app/google-analytics-manager',
  'jquery',
	'app/datalist-dropdown',
  'classList',
  'addEventListener',
  'Modernizr',
  'modernizrSelectors'],
  function (pm,goog,ga,$,datalist) {
  'use strict';

	document.body.classList.add("require-loaded");

  Modernizr.addTest('checkedselector',function(){
    return selectorSupported(':checked');
  });

  if (!Modernizr.checkedselector)
  {
    var radios = document.querySelectorAll("input[type=radio]");
    for(var r=0; r< radios.length; r++)
    {
      console.log(radios[r]);
      radios[r].style.visibility = "inherit";
    }
  }

  ga.init(); // initalize google analytics

  // if box-shadow CSS is supported, initialize the popups.
  if (Modernizr.boxshadow)
    pm.init();
  goog.init();

  var inputs = document.querySelectorAll('input[list]');
  for (var i in inputs)
  {
  	//datalist.init(inputs[i]);
  }

});