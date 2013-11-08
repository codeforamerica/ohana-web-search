// manages app initialization
require(['app/loading-manager',
	'app/popup-manager',
	'app/google-translate-manager',
	'classList',
	'addEventListener',
  'modernizr',
  'modernizrSelectors',
  'jquery',
  'checked',
	'app/datalist-dropdown'],
  function (lm,pm,goog,pfClassList,pfAddEventListener,Modernizr,ModernizrSelectors,$,pfChecked,datalist) {
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