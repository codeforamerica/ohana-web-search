// handles search filter toggle functionality
define(
	function() {
  'use strict';

  	// PRIVATE PROPERTIES
  	var _fieldsets = {};

		function init()
		{
			// capture form submission
			document.getElementById("search-form").addEventListener("submit",_formSubmitted,false);

			// initialize fieldsets
			var fieldsets = document.querySelectorAll('#search-box fieldset');
			var numFieldsets = fieldsets.length;
			var fieldset;

			for (var f = 0; f < numFieldsets; f++)
			{
				_fieldsets[fieldsets[f].id] = {};
				_fieldsets[fieldsets[f].id].legend 	= fieldsets[f].querySelector(":scope legend");
				_fieldsets[fieldsets[f].id].legend.setAttribute("data-fieldset",fieldsets[f].id);

				_fieldsets[fieldsets[f].id].toggleGroup 	= fieldsets[f].querySelector(":scope >.options");
				_fieldsets[fieldsets[f].id].currentToggle = fieldsets[f].querySelector(":scope >.current-option");
				_fieldsets[fieldsets[f].id].toggles 			= fieldsets[f].querySelectorAll(":scope .radio-group .toggle input");

				_fieldsets[fieldsets[f].id].input 	= fieldsets[f].querySelector(":scope input[type=search]");
				_fieldsets[fieldsets[f].id].hidden 	= fieldsets[f].querySelector(":scope input[type=hidden]");

				fieldset = _fieldsets[fieldsets[f].id];

				// setup event listeners
				fieldset.legend.addEventListener('mousedown',_legendClicked,false);

				var toggle;
				for (var t = 0; t < fieldset.toggles.length; t++)
				{
					toggle = fieldset.toggles[t];
					toggle.setAttribute("data-fieldset",fieldsets[f].id);
					if (t == fieldset.toggles.length-1 && fieldset.input)
					{
						toggle.addEventListener("change",_addBtnClicked,false);
						break;
					}
					toggle.addEventListener('change',_toggleClicked,false);
				}
			}
		}

		function _formSubmitted(evt)
		{
			var form = evt.target;
			var input;

			for (var f in _fieldsets)
			{
				input = _fieldsets[f].input;
				if (input && input.value != "")
				{
					_fieldsets[f].hidden.value = input.value;
					input.disabled = true;
				}
			}

			var count = 0;
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
			var fieldset = _fieldsets[legend.getAttribute("data-fieldset")];
			var toggleGroup = fieldset.toggleGroup;
			var selected = toggleGroup.querySelector(":scope input[type=radio]:checked");

			// if the fieldset has an add input field,
			// set the add checkbox value to the input field value
			if (fieldset.input)
				fieldset.toggles[fieldset.toggles.length-1].value = fieldset.input.value;

			var current = fieldset.currentToggle;
			if (legend.classList.contains('open'))
			{
				toggleGroup.classList.add('hide');
				current.querySelector(":scope div+label").innerHTML = selected.value || "All";
				current.classList.remove('hide');
				legend.className = 'closed';
			}
			else
			{
				toggleGroup.classList.remove('hide');
				current.classList.add('hide');
				legend.className = 'open';
			}
		}

		// Sets the hidden field to value of the label
		function _toggleClicked(evt)
		{
			var toggle = evt.target;
			var fieldset = _fieldsets[toggle.getAttribute("data-fieldset")];

			fieldset.hidden.value = toggle.value;

			if (fieldset.input)
				_hideAddInput(fieldset);
		}

		function _addBtnClicked(evt)
		{
			var toggle = evt.target;
			var fieldset = _fieldsets[toggle.getAttribute("data-fieldset")];

			_showAddInput(fieldset);
		}

		function _showAddInput(fieldset)
		{
			var input = fieldset.input;
			input.parentNode.childNodes[1].classList.add('hide'); // hide "Add..." text
			input.classList.remove('hide'); // show input field
			input.focus(); // give the input field focus
		}

		function _hideAddInput(fieldset)
		{
			var input = fieldset.input;
			input.value = ""; // clear input field value
			input.classList.add('hide'); // hide input field
			input.parentNode.childNodes[1].classList.remove('hide'); // show "Add..." text
		}

	return {
		init:init
	};
});