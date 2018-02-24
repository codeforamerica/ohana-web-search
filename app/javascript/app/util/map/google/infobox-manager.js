// Manages search results view Google Map.
define([
  'util/BitMask'
],
function (BitMask) {
  'use strict';

  // Module instance with map DOM and google.maps.Map instance references.
  var _mapDOM;

  // The info box to pop up when rolling over a marker.
  var _infoBox;

  // A bitmask instance for tracking the different states of the infobox.
  var _infoBoxState;

  // The possible conditions that determine the infobox's behavior.
  var STATE = {
                // The infobox is showing.
                SHOW_INFOBOX: 1,
                // The cursor is over the infobox.
                OVER_INFOBOX: 2,
                // The cursor is over the marker.
                OVER_MARKER: 4,
                // The cursor is over a spiderfier marker.
                OVER_SPIDERFY_MARKER: 8,
                // The infobox is pinned (won't disappear at mouseout).
                PIN_INFOBOX: 16,
                // A marker cluster has been expanded (spiderfied).
                HAS_SPIDERFIED: 32,
                // Mouseover event didn't fire on a marker,
                // implying a touch interface.
                IS_TOUCH: 64
              };


  // 'Constant' for delay when showing/hiding the marker info box.
  var DEFAULT_INFOBOX_DELAY = 400;

  // The timer for delaying the info box display.
  var _infoBoxDelay;

  // The marker InfoBox content that is currently showing.
  var _infoBoxContent;

  // @param mapDOM [Object] A MapDOM instance.
  // @param Infobox [Object] The info box plugin.
  function render(mapDOM, InfoBox) {
    _mapDOM = mapDOM;
    _infoBoxState = BitMask.create();

    // Turn off assumption that touch is being used initially,
    // this state is turned on if a touch event is registered.
    _infoBoxState.turnOff(STATE.IS_TOUCH);

    var infoBoxOptions = {
      disableAutoPan: false,
      pixelOffset: new google.maps.Size(7, -7),
      zIndex: null,
      infoBoxClearance: new google.maps.Size(1, 1),
      isHidden: false,
      closeBoxURL: '',
      enableEventPropagation: false
    };

    _infoBox = new InfoBox(infoBoxOptions);
  }

  // @param content [String] The content to add to the info box popup.
  function setContent(content) {
    _infoBoxContent = content;
  }

  // Register events for info box interactivity.
  function registerInfoBoxEvents() {
    google.maps.event.addListener(_infoBox, 'domready', function() {
      var contentDiv = _mapDOM.canvas.querySelector('.infoBox');
      var buttonClose = contentDiv.querySelector('.button-close');
      contentDiv.addEventListener('mousemove', _overInfoBoxHandler, false);
      contentDiv.addEventListener('mouseleave', _leaveInfoBoxHandler, false);
      buttonClose.addEventListener('mousedown', _closeInfoBoxHandler, false);
    });

    // Hack to close the info box when it moves. The spiderfier layer can
    // cause the info box to move to the last unspiderfied marker when
    // clicking a regular marker in some cases.
    google.maps.event.addListener(_infoBox, 'position_changed', function() {
      this.close();
      _infoBoxState.turnOff(STATE.SHOW_INFOBOX);
    });
  }

  function _overInfoBoxHandler() {
    _infoBoxState.turnOn(STATE.OVER_INFOBOX);
    updateInfoBoxState();
  }

  function _leaveInfoBoxHandler() {
    _infoBoxState.turnOff(STATE.OVER_INFOBOX);
    updateInfoBoxState();
  }

  function _closeInfoBoxHandler() {
    turnOffInfoBoxStates();
    updateInfoBoxState(null, 0);
  }

  // Open the global info box after a delay.
  // @param overMarker [Object] Reference to the marker the cursor is over.
  // @param delay [Number] Delay in milliseconds before opening the info box.
  //   If not specified, the delay will be the DEFAULT_INFOBOX_DELAY value.
  function _openInfoBox(overMarker, delay) {
    _infoBoxDelay = setTimeout(function () {
      _infoBox.setContent(_infoBoxContent);
      _infoBox.open(_mapDOM.map, overMarker);
      _infoBoxState.turnOn(STATE.SHOW_INFOBOX);
    }, delay);
  }

  // Open the global info box after a delay.
  // @param delay [Number] Delay in milliseconds before closing the info box.
  // If not specified, the delay will be the DEFAULT_INFOBOX_DELAY value.
  function _closeInfoBox(delay) {
    _infoBoxDelay = setTimeout(function () {
      _infoBox.close();
      _infoBoxState.turnOff(STATE.SHOW_INFOBOX);
    }, delay);
  }

  // Set the settings for the info box to its closed state.
  function turnOffInfoBoxStates() {
    _infoBoxState.turnOff(STATE.OVER_INFOBOX);
    _infoBoxState.turnOff(STATE.SHOW_INFOBOX);
    _infoBoxState.turnOff(STATE.PIN_INFOBOX);
    _infoBoxState.turnOff(STATE.OVER_MARKER);
    _infoBoxState.turnOff(STATE.OVER_SPIDERFY_MARKER);
  }

  // Update info box state. Based on the bitmask bits that are set this will
  // open or close the info box.
  // @param overMarker [Object] Reference to the marker the cursor is over.
  // @param delay [Number] Delay in milliseconds before closing the info box.
  function updateInfoBoxState(overMarker, delay) {
    // Clear any transitions in progress.
    if (_infoBoxDelay) clearTimeout(_infoBoxDelay);

    // If delay is not set use the default delay value.
    var setDelay = delay !== undefined ? delay : DEFAULT_INFOBOX_DELAY;

    if (  _infoBoxState.isOn(STATE.OVER_MARKER) &&
          _infoBoxState.isOff(STATE.OVER_SPIDERFY_MARKER) &&
          (_infoBoxState.isOff(STATE.SHOW_INFOBOX) ||
           _infoBox.getContent() !== _infoBoxContent)
      ) {
      _openInfoBox(overMarker, setDelay);
    }
    else if ( _infoBoxState.isOff(STATE.PIN_INFOBOX) &&
              _infoBoxState.isOff(STATE.OVER_INFOBOX) &&
              _infoBoxState.isOff(STATE.OVER_MARKER) )  {
      _closeInfoBox(setDelay);
    }
  }

  function turnOff(state) {
    _infoBoxState.turnOff(state);
  }

  function turnOn(state) {
    _infoBoxState.turnOn(state);
  }

  function isOff() {
    return _infoBoxState.isOff();
  }

  function isOn() {
    return _infoBoxState.isOn();
  }

  return {
    render:render,
    turnOffInfoBoxStates:turnOffInfoBoxStates,
    updateInfoBoxState:updateInfoBoxState,
    registerInfoBoxEvents:registerInfoBoxEvents,
    setContent:setContent,
    STATE:STATE,
    turnOff:turnOff,
    turnOn:turnOn,
    isOff:isOff,
    isOn:isOn
  };
});
