// Sets up script initialization based on page loading events.

// loads main namespaced object
var module = (function (module,window,document,undefined) {
	"use strict";

	// run scripts when DOM has fully loaded
	document.addEventListener("DOMContentLoaded", function() {
			module.busyManager.init(); // initialize help/info screen (in utility bar)
	});

return module;

})(module || {}, this,document)