// Manages interactivity of a button for interacting with the map size.
define([
  'util/EventObserver'
],
function (eventObserver) {
  'use strict';

  // @param selector [String] DOM selector for the map size control button.
  // @return [Object] A MapSizeControl instance.
  function create(selector) {
    return new MapSizeControl(selector);
  }

  // @param selector [String] DOM selector for the map size control button.
  // @return [Object] A MapSizeControl instance.
  function MapSizeControl(selector) {
    var _instance = this;

    // The events this instance broadcasts.
    var _events = { CLICK: 'click' };
    eventObserver.attach(this);

    // The DOM element that controls the expanding/contracting of the map.
    var _buttonElm = document.querySelector(selector);

    // Whether the map is at its max size or not.
    var _atMaxSize = false;

    // 'Constants' for map button text content.
    var LARGER_MAP_TEXT = "<i class='fa fa-minus-square'></i> Smaller map"; // jshint ignore:line
    var SMALLER_MAP_TEXT = "<i class='fa fa-plus-square'></i> Larger map"; // jshint ignore:line

    function _init() {
      _buttonElm.innerHTML = SMALLER_MAP_TEXT;
      _buttonElm.removeAttribute('disabled');
      _buttonElm.addEventListener('click', _buttonElmClicked, false);
    }

    // Map size control was clicked. This control toggles the large & small map.
    function _buttonElmClicked(evt) {
      _atMaxSize = !_atMaxSize;
      _buttonElm.innerHTML = _atMaxSize ? LARGER_MAP_TEXT : SMALLER_MAP_TEXT;
      _instance.dispatchEvent(_events.CLICK, {target:_instance});
      evt.preventDefault();
    }

    _init();

    return _instance;
  }

  return {
    create:create
  };
});
