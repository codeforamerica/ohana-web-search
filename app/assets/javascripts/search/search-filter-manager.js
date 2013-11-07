// handles search filter toggle functionality
define(
	function() {
  'use strict';

  	// PRIVATE PROPERTIES
  	var _fieldsets = {}; // set of all fieldsets

  	// main module initialization
  	function init()
  	{
			// capture form submission
			var searchForm = document.getElementById("search-form");
			searchForm.addEventListener("submit",_formSubmitted,false);

			// initialize fieldsets
			var fieldsets = document.querySelectorAll('#search-box fieldset');
			var numFieldsets = fieldsets.length;
			var fs; // individual fieldset

			// instantiate new fieldset objects and place in set of fieldsets
			for (var f = 0; f < numFieldsets; f++)
			{
	      fs = new fieldset();
	      fs.init(fieldsets[f]);
	      _fieldsets[fs.getId()] = fs;
	    }
  	}

  	// Handle form submission
  	function _formSubmitted(evt)
		{
			var form = evt.target;
			var input;

			for (var f in _fieldsets)
			{
				input = _fieldsets[f].getInput();
				if (input && input.value != "")
				{
					_fieldsets[f].getHidden().value = input.value;
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


		// New fieldset instance constructor
  	var fieldset = function() {

  		// fieldset components
  		var _fieldset;
  		var _id;
  		var _legend;
  		var _toggleGroupsContainer;
  		var _toggleGroups;
  		var _currentToggle;
  		var _currentLabel;
  		var _toggles = [];
  		var _input;
  		var _inputCheckbox;
  		var _hidden;

  		var _inputShowing = false; // whether or not the input field is showing

			function init(fieldset)
			{
				_fieldset = fieldset;
				_id = _fieldset.id;

				_legend = _fieldset.querySelector("legend");

				_toggleGroupsContainer 		= _fieldset.querySelector(".options");
				_currentToggle 						= _fieldset.querySelector(".current-option");
				_currentLabel 						= _currentToggle.querySelector("div+label");
				_toggleGroups 						= _fieldset.querySelectorAll(".radio-group");

				_input 										= _fieldset.querySelector("input[type=search]");
				_hidden 									= _fieldset.querySelector("input[type=hidden]");

				// setup event listeners
				_legend.addEventListener('mousedown',_legendClicked,false);

				var group;
				var toggle;
				for (var g = 0; g < _toggleGroups.length; g++)
				{
					group = _toggleGroups[g];
					group.addEventListener("mousedown",_toggleClicked,false);
					toggle = group.querySelector(".toggle input");
					_toggles.push(toggle);

					if (g == _toggleGroups.length-1 && _input)
					{
						toggle.addEventListener("change",_addBtnClicked,false);
						break;
					}
					toggle.addEventListener('change',_toggleChanged,false);
				}

				_inputCheckbox = _toggles[_toggles.length-1];

				// The input text field is showing if it has a value
				if(_input && _input.value)
					_inputShowing = true;
			}

			// GETTERS
			// Publically exposed getters for properties
			function getId()
			{
				return _id;
			}

			function getInput()
			{
				return _input;
			}

			function getHidden()
			{
				return _hidden;
			}

			// EVENT HANDLERS
			// The legend was clicked.
			function _legendClicked(evt)
			{
				_toggleFilter(_fieldset);
			}

			// Toggle clicked event handler.
			function _toggleClicked(evt)
			{
				var toggle = evt.currentTarget.querySelector(".toggle input");
				var current = evt.target;

				// do not toggle the filter if the checkbox is checked or what was clicked is
				// the add field input or drop-down menu.
				if (toggle.checked && current.tagName == "LABEL")
					_toggleFilter(_fieldset);
			}

			// Toggle changed event handler.
			// Sets the hidden field to value of the label.
			function _toggleChanged(evt)
			{
				var toggle = evt.target;
				_hidden.value = toggle.value;

				// If the add input field is showing, hide it.
				if (_inputShowing)
					_hideAddInput(_fieldset);
			}

			function _addBtnClicked(evt)
			{
				var toggle = evt.target;
				_showAddInput(_fieldset);
			}


			// Show/hide the filter
			function _toggleFilter(fieldset)
			{
				var selected;
				try
				{
					selected = _toggleGroupsContainer.querySelector("input[type=radio]:checked");
				}
				// catch IE 8
				catch(e)
				{
					arr = _toggleGroupsContainer.querySelectorAll("input[type=radio]");
					for (var a=0; a<arr.length;a++)
					{
						arr[a].style.visibility = "inherit";
						if (arr[a].checked)
							selected = arr[a];
					}
				}

				// if the fieldset has an add input field,
				// set the add checkbox value to the input field value
				if (_input)
					_inputCheckbox.value = _input.value;

				if (_legend.classList.contains('open'))
				{
					_toggleGroupsContainer.classList.add('hide');
					_currentLabel.innerHTML = selected.getAttribute("data-display-value") || selected.value || "All";

					if (!selected.value)
						_setToggle(_toggles[1]); // set toggle to "All"

					_currentToggle.classList.remove('hide');
					_legend.className = 'closed';
				}
				else
				{
					_toggleGroupsContainer.classList.remove('hide');
					_currentToggle.classList.add('hide');
					_legend.className = 'open';
				}
			}

			// Sets a particular toggle to checked.
			// Sets the checked attribute and imitates a 'change' event.
			// @param toggle [Object] The toggle to check.
			function _setToggle(toggle)
			{
				toggle.checked = true;
				_toggleChanged({target:toggle});
			}

			function _showAddInput()
			{
				_input.parentNode.childNodes[1].classList.add('hide'); // hide "Add..." text
				_input.classList.remove('hide'); // show input field
				_input.focus(); // give the input field focus
				_inputShowing = true;
			}

			function _hideAddInput()
			{
				_input.value = ""; // clear input field value
				_input.classList.add('hide'); // hide input field
				_input.parentNode.childNodes[1].classList.remove('hide'); // show "Add..." text
				_inputShowing = false;
			}

    return {
      init:init,
      getId:getId,
      getInput:getInput,
      getHidden:getHidden
    };

  };

	return {
		init:init
	};
});