// handles search filter toggle functionality
define(
	function() {
  'use strict';

  	// PRIVATE PROPERTIES
  	var _fieldsets;

		function init()
		{
			var searchForm = document.getElementById("search-form");
			searchForm.addEventListener("submit",_formSubmitted,false);

			_fieldsets = document.querySelectorAll('#search-box fieldset');
			var toggles;
			for (var f = 0; f < _fieldsets.length; f++)
			{
				_fieldsets[f].querySelector(':scope legend').addEventListener('mousedown',_legendClicked,false);
				toggles = _fieldsets[f].querySelectorAll(':scope .radio-group .toggle input');
				for (var t = 0; t < toggles.length-1; t++)
				{
					toggles[t].addEventListener('change',_toggleClicked,false);
				}
				toggles[toggles.length-1].addEventListener("change",_addBtnClicked,false)
			}
		}

		function _formSubmitted(evt)
		{
			var form = evt.target;
			var count = 0;
			var input;
			var hidden;

			for (var f = 0; f < _fieldsets.length; f++)
			{
				input = _fieldsets[f].querySelector(':scope input[type=search]');
				hidden = _fieldsets[f].querySelector(':scope input[type=hidden]');
				if (input.value != "")
				{
					hidden.value = input.value;
					input.value = "";
				}
			}

			while(form[count] != undefined)
			{
				input = form[count++];
				if (input.value == "" || input.type == "radio")
					input.disabled = true;
			}



			form.submit();

			evt.preventDefault();
			return false;
		}

		function _legendClicked(evt)
		{
			var legend = evt.target;
			var toggleGroup = legend.parentNode.querySelector(":scope >.options");
			if (legend.classList.contains('open'))
			{
				toggleGroup.className = 'hide';
				//toggleGroup.querySelector(":scope input:first-child").checked = true;
				//toggleGroup.querySelector(":scope input[type=hidden]").value = "";
				legend.className = 'closed';
			}
			else
			{
				toggleGroup.className = '';
				legend.className = 'open';
			}
		}

		// Sets the hidden field to value of the label
		function _toggleClicked(evt)
		{
			var toggle = evt.target;
			var label = document.getElementById(toggle.id+"_label");
			var group = toggle.name.substring(0,toggle.name.length-7);
			var hidden = document.getElementById(group);
			hidden.value = toggle.value;
			_hideAddInput(group+"_option_input");
		}

		function _addBtnClicked(evt)
		{
			var group = evt.target.name+"_input";
			_showAddInput(group);
		}

		function _showAddInput(id)
		{
			var input = document.getElementById(id);
			input.parentNode.childNodes[1].classList.add('hide'); // hide "Add..." text
			input.classList.remove('hide'); // show input field
			input.focus(); // give the input field focus
		}

		function _hideAddInput(id)
		{
			var input = document.getElementById(id);
			input.value = ""; // clear input field value
			input.classList.add('hide'); // hide input field
			input.parentNode.childNodes[1].classList.remove('hide'); // show "Add..." text
		}

	return {
		init:init
	};
});