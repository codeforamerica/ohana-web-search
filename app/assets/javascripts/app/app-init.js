// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
  'app/google-analytics-manager',
  'jquery',
	'app/datalist-dropdown',
  'classList',
  'addEventListener',
  'checked',
  'Modernizr',
  'modernizrSelectors'],
  function (lm,pm,goog,ga,$,datalist) {
  'use strict';

	document.body.classList.add("require-loaded");

  Modernizr.addTest('checkedselector',function(){
    return selectorSupported(':checked');
  });

  Modernizr.load([
    {
        test: Modernizr.checkedselector,
        nope: $.fn.checkedPolyfill,
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