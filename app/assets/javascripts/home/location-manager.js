// manages results maps view
define(function () {
	'use strict';

		// PRIVATE PROPERTIES
		var _showLocationBtn;
		var _locationSearchBtn;
		var _locationBox;
		var _locationField;

		// PUBLIC METHODS
		function init(callback)
		{
			_showLocationBtn = document.getElementById('location-btn');
			_locationSearchBtn = document.getElementById('location-search-btn');
			_locationBox = document.getElementById('location-box');
			_locationField = document.getElementById('location');

			_showLocationBtn.addEventListener('click', _showLocationBtnClicked, false);

			var closeBtn = _locationBox.childNodes[1].childNodes[9]; // hackish way to find the close button, but it's fast
			closeBtn.addEventListener('click',_closeBtnClicked,false);

			// temp
			document.getElementById('find-current-location').onclick = function(){
				alert('Feature is still being implemented, check back soon!')}
		}

		function _closeBtnClicked(evt)
		{
			_locationBox.classList.add('hide');
			if (_locationField.value)
				_dispatchSubmitBtn();
		}

		function _showLocationBtnClicked(evt)
		{
			_locationBox.classList.remove('hide');
		}

		function _dispatchSubmitBtn()
		{
			if(document.createEvent)
			{
			    var click = document.createEvent("MouseEvents");
			    click.initMouseEvent("click", true, true, window,
			    0, 0, 0, 0, 0, false, false, false, false, 0, null);
			    _locationSearchBtn.dispatchEvent(click);
			    _locationSearchBtn.focus();
			}
			else if(document.documentElement.fireEvent)
			{
			    _locationSearchBtn.fireEvent("onclick");
			    _locationSearchBtn.focus();
			}
		}

	return {
		init:init
	};
});
