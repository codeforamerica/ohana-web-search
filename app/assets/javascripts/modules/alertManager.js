// manages closing of alert box
var module = (function (module) {

	module.alertManager = (function (alertManager) {

		// PRIVATE PROPERTIES
		var alertBox; // alert message box

		// PUBLIC METHODS
		alertManager.init = function()
		{
			alertBox = document.getElementById("alert-box");

			alertBox.addEventListener("mousedown", closeHandler, false)
		}

		// PRIVATE METHODS
		function closeHandler(evt)
		{
			// if clicked element has a close class, remove alert box content
			if (evt.target.classList.contains("close")) alertBox.innerHTML = "";
		}

		return alertManager;
	})({});

	return module;
})(module || {})