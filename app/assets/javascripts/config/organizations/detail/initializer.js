// Sets up script initialization based on page loading events.

// loads main namespaced object
var module = (function (module,window,document,undefined) {
	"use strict";

	// run scripts when DOM has fully loaded
	document.addEventListener("DOMContentLoaded", function() {
			module.busyManager.init(); // initialize help/info screen (in utility bar)
			module.infoScreenManager.init(); // initialize help/info screen (in utility bar)
			module.alertManager.init(); // intialize alert box manager
			module.searchOpManager.init(); // search options functionality
			module.popupManager.init(); // initialize popup behavior
			module.ajaxSearch.init(); // initialize ajax search
	});

return module;

})(module || {}, this,document)