// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
  'app/google-analytics-manager',
	'classList',
	'addEventListener',
  'Modernizr',
  'modernizrSelectors',
  'jquery',
  'checked',
	'app/datalist-dropdown'],
  function (lm,pm,goog,ga,pfClassList,pfAddEventListener,Modernizr,ModernizrSelectors,$,pfChecked,datalist) {
  'use strict';

	document.body.classList.add("require-loaded");

  Modernizr = window.Modernizr;
  Modernizr.addTest('checkedselector',function(){
    return selectorSupported(':checked');
  });

  Modernizr.load([
    {
        test: Modernizr.checkedselector,
        nope: pfChecked,
        callback: function() {
            jQuery(function(){
                $('input:radio').checkedPolyfill();
            });
        }
    }
  ]);

  ga.init(); // initalize google analytics
  lm.hide();
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