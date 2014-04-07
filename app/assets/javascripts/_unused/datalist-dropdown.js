// creates a dropdown menu based on a datalist
define(function() {
  'use strict';

  var _inputs = {};

  function init(input)
  {
    // alternative list query code for Safari
    if (input.list === undefined && input.tagName === "INPUT") input.list = document.getElementById(input.getAttribute('list'));

    if (input.list)
    {
      var i = new item();
      i.init(input);
      _inputs[i.id] = i;
    }
  }

  var item = function() {

    var id; // the input id used by this datalist-dropdown item

    var _input; // the associated <input> field
    var _list;  // the associated <ul>
    var _items; // the associated array of <li>
    var _showingItems = []; // array <li> that are actually visible
    var _arrowKeyPosition = -1; // the arrow key position when navigating via arrow key
    var _lastHighlighted; // the last highlighted <li>

    function init(input)
    {
      //if ( !(this instanceof init) )
      //  return new init(input);

      _input = input;
      id = _input.id;

      id = _input.list.id+"-drop-down";
      var container = _input.parentNode;
      var ul = document.createElement('ul');
      ul.id = id;
      ul.className = "drop-down hide";
      ul.innerHTML = String(_input.list.innerHTML).replace(/(<\s*\/?\s*)option(\s*([^>]*)?\s*>)/gi, "$1li$2");
      container.appendChild(ul);
      _list = container.querySelector("#"+id);

      container.classList.add("drop-down-container");


      _items = _list.children;
      var item;
      for (var c=0; c < _items.length; c++)
      {
        item = _items[c];
        //item.style.height = offsets.height;
        item.setAttribute("data-input",_input.id);
        item.addEventListener("mousedown",_itemClicked,false);

        _checkIfVisible(item);
      }

      _input.autocomplete = "off";
      _input.list.id = ""; // break reference to datalist
      _input.addEventListener("keyup",_inputChanged,false);
      _input.addEventListener("focus",_inputFocus,false);
      _input.addEventListener("blur",_inputBlur,false);
      _input.addEventListener("mousedown",_inputClicked,false);

    }

    function _inputClicked(evt)
    {
      if (_list.classList.contains('hide'))
        _showList();
      else
        _hideList();
    }

    function _inputFocus(evt)
    {
      _showList();

      var offsets = {
        top:_input.offsetTop,
        left:_input.offsetLeft,
        width:_input.offsetWidth,
        height:_input.offsetHeight
      };

      _list.style.top = offsets.top+offsets.height+"px";
      _list.style.left = offsets.left+"px";
      _list.style.width = offsets.width+"px";
      _list.style.height = (offsets.height*5)+"px";
      _list.style.borderTop = "none";

      _arrowKeyPosition = -1;
    }

    function _inputBlur(evt)
    {
      _hideList();
    }

    // input text is changed (e.g. user typed something)
    function _inputChanged(evt)
    {
      if (_list.classList.contains('hide'))
        _showList();
      if (_input.value.length === 0)
        _hideList();

      // down or up arrow pressed
      if (evt.keyCode === 40 || evt.keyCode === 38)
      {
        var increment = function(){ _arrowKeyPosition = (++_arrowKeyPosition > _showingItems.length) ? _showingItems.length-1 : _arrowKeyPosition; };
        var decrement = function(){ _arrowKeyPosition = (--_arrowKeyPosition < 0) ? 0 : _arrowKeyPosition; };
        evt.keyCode === 40 ? increment() : decrement();

        var item = _showingItems[_arrowKeyPosition];
        item.classList.add("highlight");
        if (_lastHighlighted)
          _lastHighlighted.classList.remove("highlight");
        _lastHighlighted = item;

        _input.value = item.innerHTML.trim();
      }
      else
      {
        if (_lastHighlighted)
          _lastHighlighted.classList.remove("highlight");

        var aggregateHeight = 0;
        _showingItems = [];
        for (var l=0;l<_items.length;l++)
        {
          _checkIfVisible(_items[l]);
          //aggregateHeight += _items[l].offsetHeight;
        }
      }

      var heightVal = 30 * ( _showingItems.length > 6 ? 6 : _showingItems.length );
      _list.style.height = heightVal+"px";

      // no items showing
      if (_showingItems.length === 0)
      {
        _list.classList.add('hide');
      }


    }

    // checks if a particular item in the drop-down menu is visible or not
    function _checkIfVisible(item)
    {
      var val = _input.value.toLowerCase();
      var itemVal = item.innerHTML.trim().toLowerCase();

      if (val.length < 3)
      {
        if (itemVal.substr(0,val.length) === val)
          _showItem(item);
        else
          _hideItem(item);
      }
      else
      {
        if (itemVal.indexOf(_input.value.toLowerCase()) !== -1)
          _showItem(item);
        else
          _hideItem(item);
      }
    }

    // show an item in the drop-down
    function _showItem(item)
    {
      item.classList.remove("hide");
      _showingItems.push(item);
    }

    // hide an item in the drop-down
    function _hideItem(item)
    {
      item.classList.add("hide");
    }

    function _showList()
    {
      if (_showingItems.length > 0)
        _list.classList.remove('hide');
    }

    function _hideList()
    {
      _list.classList.add('hide');
    }

    function _itemClicked(evt)
    {
      var item = evt.target;
      var id = "#"+item.getAttribute("data-input");
      var input = item.parentNode.parentNode.querySelector(id);
      input.value = item.innerHTML.trim();
    }

    return {
      init:init,
      id:id
    };

  };

  return {
    init:init
  };
});