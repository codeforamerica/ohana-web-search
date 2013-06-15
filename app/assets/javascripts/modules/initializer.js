// Sets up script initialization based on page loading events.

// loads main namespaced object
(function (window,document,undefined) {
	"use strict";
	
	window.module = {

		init:function()
		{
			console.log("init");

		}
	};

	// run scripts when DOM has fully loaded
	document.addEventListener("DOMContentLoaded", function() {
		module.init(); // main initialization of custom script happens here
	});

})(this,document)