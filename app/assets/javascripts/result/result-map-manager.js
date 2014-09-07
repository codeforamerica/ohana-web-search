// Manages search results view Google Map.
define([
  'util/BitMask',
  'util/map/marker-manager',
  'util/map/google-maps-loader',
  'domReady!'
],
function (BitMask, markerManager, googleMaps) {
  'use strict';

  // The <div> element that the Google map loads into.
  var _map;

  // The parent HTML element of the map.
  var _mapCanvas;

  // The element that controls the expanding/contracting of the map.
  var _mapSizeControl;

  // Whether the map is at its max size or not.
  var _atMaxSize = false;

  // Parsed JSON object of map marker data (positioning, label, etc.).
  var _markerData;

  // The collective map bounds of the markers.
  var _markerBounds;

  // 'Constants' for map button text content.
  var LARGER_MAP_TEXT = "<i class='fa fa-minus-square'></i> Smaller map";
  var SMALLER_MAP_TEXT = "<i class='fa fa-plus-square'></i> Larger map";

  // Default 'constants' that get set to the specific marker kinds
  // listed above at runtime.
  var LARGE_MARKER_URL;
  var SMALL_MARKER_URL;
  var LARGE_SPIDERFY_MARKER_URL;
  var SMALL_SPIDERFY_MARKER_URL;

  // The spiderfier layer for handling overlapping markers.
  // See https://github.com/jawj/OverlappingMarkerSpiderfier
  var _spiderfier;

  // The info box to pop up when rolling over a marker.
  var _infoBox;

  // 'Constant' for delay when showing/hiding the marker info box.
  var DEFAULT_INFOBOX_DELAY = 400;

  // A bitmask instance for tracking the different states of the infobox.
  var _infoBoxState;

  // The possible conditions that determine the infobox's behavior.
  // The infobox is showing.
  var SHOW_INFOBOX = 1;

  // The cursor is over the infobox.
  var OVER_INFOBOX = 2;

  // The cursor is over the marker.
  var OVER_MARKER = 4;

  // The cursor is over a spiderfier marker.
  var OVER_SPIDERFY_MARKER = 8;

  // The infobox is pinned (it doesn't disappear when mouseout occurs).
  var PIN_INFOBOX = 16;

  // A marker cluster has been expanded (spiderfied).
  var HAS_SPIDERFIED = 32;

  // The mouseover event didn't fire on a marker, implying a touch interface.
  var IS_TOUCH = 64;

  // The timer for delaying the info box display.
  var _infoBoxDelay;

  // The marker the cursor is currently over.
  var _overMarker;

  // The marker InfoBox content that is currently showing.
  var _infoBoxContent;

  function init() {
    googleMaps.load(_loadPlugins);
  }

  function _loadPlugins() {
    // Only check for result map if the page isn't showing the no search
    // results view.
    var noResults = document.querySelector('#results-entries .no-results');
    if (!noResults) {
      var mapContainer = document.getElementById('map-view');
      if (mapContainer) {
        // ------------------------------------------------------------------
        // Load Google Map plugin modules.
        require([
          'gmapsOMS',
          'gmapsInfobox'
        ],
        function(OverlappingMarkerSpiderfier, InfoBox) {
            _renderMap(OverlappingMarkerSpiderfier, InfoBox);
        });
        // ------------------------------------------------------------------
      }
      else {
        console.log('Warning: The search result map container was not found!');
      }
    }
  }

  function _renderMap(OverlappingMarkerSpiderfier, InfoBox) {
    if (!OverlappingMarkerSpiderfier || !InfoBox)
      throw new Error('Not all required Google Maps plugins loaded properly!');

    _infoBoxState = BitMask.create();

    // Turn off assumption that touch is being used initially, this is turned
    // on if a touch event is registered.
    _infoBoxState.turnOff(IS_TOUCH);

    var mapView = document.getElementById('map-view');
    mapView.classList.remove('hide');

    _mapCanvas = document.getElementById('map-canvas');
    _mapSizeControl = document.getElementById('map-size-control');
    _mapSizeControl.innerHTML = SMALLER_MAP_TEXT;
    _mapSizeControl.removeAttribute('disabled');

    // Turns off Google Points-Of-Interest (POI) markers so the user
    // doesn't click a POI and get an infowindow popped up.
    var poiStyles =[
      {
        featureType: 'poi',
        elementType: 'labels',
        stylers: [
          { visibility: 'off' }
        ]
      }
    ];

    var mapOptions = {
      zoom: 15,
      scrollwheel: false,
      zoomControl: true,
      panControl: false,
      streetViewControl: false,
      scaleControl: true,
      scaleControlOptions: {
        position: google.maps.ControlPosition.RIGHT_BOTTOM
      },
      mapTypeControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      styles: poiStyles
    };

    var spiderfierOptions = {
      legWeight: 2,
      circleFootSeparation: 30,
      keepSpiderfied: true,
      nearbyDistance: 40
    };

    var infoBoxOptions = {
      disableAutoPan: false,
      pixelOffset: new google.maps.Size(7, -7),
      zIndex: null,
      infoBoxClearance: new google.maps.Size(1, 1),
      isHidden: false,
      closeBoxURL: '',
      enableEventPropagation: false
    };

    _map = new google.maps.Map(_mapCanvas, mapOptions);
    _spiderfier = new OverlappingMarkerSpiderfier(_map,
                                                  spiderfierOptions);
    _infoBox = new InfoBox(infoBoxOptions);

    _loadMarkers();
    _refresh();

    // Register events for map interactivity.
    google.maps.event.addListener(_map, 'idle', _mapIdle);
    google.maps.event.addListener(_map, 'click', _mapClick);
    _mapSizeControl.addEventListener('click',
                                     _mapSizeControlClicked, false);

    _mapCanvas.addEventListener('touchstart', _mapTouch, false);

    // Register events for info box interactivity.
    google.maps.event.addListener(_infoBox, 'domready', function() {
      var contentDiv = _mapCanvas.querySelector('.infoBox');
      var buttonClose = contentDiv.querySelector('.button-close');
      contentDiv.addEventListener('mousemove',
                                  _overInfoBoxHandler, false);
      contentDiv.addEventListener('mouseleave',
                                  _leaveInfoBoxHandler, false);
      buttonClose.addEventListener('mousedown',
                                   _closeInfoBoxHandler, false);
    });

    // Hack to close the info box when it moves. The spiderfier layer can
    // cause the info box to move to the last unspiderfied marker when
    // clicking a regular marker in some cases.
    google.maps.event.addListener(_infoBox,
                                  'position_changed', function(evt) {
      this.close();
      _infoBoxState.turnOff(SHOW_INFOBOX);
    });
  }

  // Event handler for when the map is idle. This is used by the spiderfier
  // to style the map markers that will spiderfy when clicked.
  function _mapIdle() {
    _setAllIcons();
    google.maps.event.addListener(_map, 'zoom_changed', _mapZoomed);
    // Remove idle listeners as they aren't needed after the spiderfied markers
    // are styled for the first time.
    google.maps.event.clearListeners(_map, 'idle');
  }

  // Event handler for when the map is zoomed. This is used by the spiderfier
  // to handle style changes to the map markers that will spiderfy when clicked.
  function _mapZoomed() {
    _setAllIcons();
  }

  // Event handler for when the map is clicked. This is used to close
  // any currently open info box.
  function _mapClick() {
    _turnOffInfoBoxStates();
    _updateInfoBoxState(0);
  }

  // Event handler for when a touch event occurs on the map, for
  // changing the interactivity to accommodate lack of mouseover/out events.
  function _mapTouch() {
    _infoBoxState.turnOn(IS_TOUCH);
    _mapCanvas.removeEventListener('touchstart', _mapTouch, false);
  }

  function _overInfoBoxHandler(evt) {
    _infoBoxState.turnOn(OVER_INFOBOX);
    _updateInfoBoxState();
  }

  function _leaveInfoBoxHandler(evt) {
    _infoBoxState.turnOff(OVER_INFOBOX);
    _updateInfoBoxState();
  }

  function _closeInfoBoxHandler(evt) {
    _turnOffInfoBoxStates();
    _updateInfoBoxState(0);
  }

  // Run through the markers and set them to a spiderfied large or small
  // appearance based on the size of the map.
  function _setAllIcons() {

    // Style all markers.
    var markers = _spiderfier.getMarkers();
    var index = markers.length - 1;
    while(index >= 0) {
      _setIcon(markers[index--], false);
    }

    // Style spiderfier markers.
    markers = _spiderfier.markersNearAnyOtherMarker();
    index = markers.length - 1;
    while(index >= 0) {
      _setIcon(markers[index--], true);
    }
  }

  // Set the icon for a marker to the large or small regular
  // or spiderfied marker.
  // @param marker [Object] a map marker.
  // @param useSpiderfied [Boolean] true if the spiderfied marker should
  // be used, false otherwise.
  function _setIcon(marker, useSpiderfied) {
    var manager = marker.manager;
    if (useSpiderfied) {
      if (_atMaxSize)
        manager.turnOn(manager.LARGE_ICON | manager.SPIDERFIED_ICON);
      else
        manager.turnOn(manager.SMALL_ICON | manager.SPIDERFIED_ICON);
    }
    else {
      if (_atMaxSize)
        manager.turnOn(manager.LARGE_ICON | manager.UNSPIDERFIED_ICON);
      else
        manager.turnOn(manager.SMALL_ICON | manager.UNSPIDERFIED_ICON);
    }
    marker.setIcon(manager.getIcon());
  }

  // Updates the marker icons to the size set for the map.
  function _updateMarkerSizes() {
    var markers = _spiderfier.getMarkers();
    var index = markers.length - 1;
    var marker;
    while(index >= 0) {
      marker = markers[index--];
      marker.setIcon(marker.manager.getIcon());
    }
  }

  // Map size control was clicked. This control toggles the large & small map.
  function _mapSizeControlClicked(evt) {
    if (_atMaxSize) {
      _mapCanvas.classList.remove('max');
      _mapSizeControl.innerHTML = SMALLER_MAP_TEXT;
      _atMaxSize = false;
    }
    else {
      _mapCanvas.classList.add('max');
      _mapSizeControl.innerHTML = LARGER_MAP_TEXT;
      _atMaxSize = true;
    }
    _updateMarkerSizes();
    _refresh();

    evt.preventDefault();
  }

  // Loads the map markers.
  function _loadMarkers() {
    var locations = document.getElementById('map-locations');
    if (locations) {
      // Load the map marker data from the JSON map data embedded in the DOM.
      _markerData = JSON.parse(locations.innerHTML);

      // Remove the script element from the DOM
      locations.parentNode.removeChild(locations);
      _markerBounds = new google.maps.LatLngBounds();

      var index = _markerData.length - 1;
      var marker;
      while(index >= 0) {
        marker = _loadMarker(_markerData[index--]);
      }

      _overMarker = marker;
    }
  }

  // Load a single map marker.
  // @returns [Object] A google.maps.Marker instance that was created,
  // or null if there isn't a latitude and longitude in the data.
  function _loadMarker(markerData) {
    var marker = null;
    if (markerData.latitude && markerData.longitude) {
      var myLatLng = new google.maps.LatLng(markerData.latitude,
                                            markerData.longitude);

      var markerProxy = markerManager.create(markerData.kind);

      if (_atMaxSize)
        markerProxy.turnOn(markerProxy.LARGE_ICON);
      else
        markerProxy.turnOn(markerProxy.SMALL_ICON);

      var markerOptions = {
        map: _map,
        position: myLatLng,
        icon: markerProxy.getIcon(),
        optimized: false,
        manager: markerProxy
      };
      marker = new google.maps.Marker(markerOptions);

      _spiderfier.addMarker(marker);

      var mainName = markerData.name;
      var orgName = markerData.org_name;
      var agency = '';
      if (orgName !== markerData.name)
        agency = '<h2>' + orgName + '</h2>';

      var content = "<div><div class='button-close'></div>" +
                    '<h1>' + mainName + '</h1>' + agency +
                    '<p>' + markerData.street_address + ', ' +
                    markerData.city + '</p>' + "<p><a href='/locations/" +
                    markerData.slug+(window.location.search) +
                    "'>View more details…</a></p></div>";

      _makeInfoBoxEvent(marker, content);

      _markerBounds.extend(myLatLng);
    }

    return marker;
  }

  // Open the global info box after a delay.
  // @param delay [Number] Delay in milliseconds before opening the info box.
  // If not specified, the delay will be the DEFAULT_INFOBOX_DELAY value.
  function _openInfoBox(delay) {
    _infoBoxDelay = setTimeout(function () {
      _infoBox.setContent(_infoBoxContent);
      _infoBox.open(_map, _overMarker);
      _infoBoxState.turnOn(SHOW_INFOBOX);
    }, delay);
  }

  // Open the global info box after a delay.
  // @param delay [Number] Delay in milliseconds before closing the info box.
  // If not specified, the delay will be the DEFAULT_INFOBOX_DELAY value.
  function _closeInfoBox(delay) {
    _infoBoxDelay = setTimeout(function () {
      _infoBox.close();
      _infoBoxState.turnOff(SHOW_INFOBOX);
    }, delay);
  }

  // Set the settings for the info box to its closed state.
  function _turnOffInfoBoxStates() {
    _infoBoxState.turnOff(OVER_INFOBOX);
    _infoBoxState.turnOff(SHOW_INFOBOX);
    _infoBoxState.turnOff(PIN_INFOBOX);
    _infoBoxState.turnOff(OVER_MARKER);
    _infoBoxState.turnOff(OVER_SPIDERFY_MARKER);
  }

  // Update info box state. Based on the bitmask bits that are set this will
  // open or close the info box.
  // @param delay [Number] Delay in milliseconds before closing the info box.
  function _updateInfoBoxState(delay) {
    // Clear any transitions in progress.
    if (_infoBoxDelay) clearTimeout(_infoBoxDelay);

    // If delay is not set use the default delay value.
    var setDelay = delay !== undefined ? delay : DEFAULT_INFOBOX_DELAY;

    if (  _infoBoxState.isOn(OVER_MARKER) &&
          _infoBoxState.isOff(OVER_SPIDERFY_MARKER) &&
          (_infoBoxState.isOff(SHOW_INFOBOX) ||
           _infoBox.getContent() !== _infoBoxContent)
      ) {
      _openInfoBox(setDelay);
    }
    else if ( _infoBoxState.isOff(PIN_INFOBOX) &&
              _infoBoxState.isOff(OVER_INFOBOX) &&
              _infoBoxState.isOff(OVER_MARKER) )  {
      _closeInfoBox(setDelay);
    }
  }

  // Make info box events associated with a map marker.
  // @param marker [Object] The marker that triggered the opening of the
  // info box.
  // @param content [String] The text content of the info box.
  function _makeInfoBoxEvent(marker, content) {

    // Change marker icon appearances when the markers spiderfy.
    _spiderfier.addListener('spiderfy', function(spiderfied, unspiderfied) {
      _infoBoxState.turnOn(HAS_SPIDERFIED);
      var index = spiderfied.length - 1;
      while(index >= 0) {
        _setIcon(spiderfied[index--], false);
      }
    });

    // Change marker icon appearances when the markers unspiderfy.
    _spiderfier.addListener('unspiderfy', function(spiderfied, unspiderfied) {
      var index = spiderfied.length - 1;
      while(index >= 0) {
        _setIcon(spiderfied[index--], true);
      }
    });

    // Register the marker the cursor has rolled over.
    google.maps.event.addListener(marker, 'mouseover', function() {
      if (_overMarker !== marker) _infoBoxState.turnOff(PIN_INFOBOX);
      if (_infoBoxState.isOff(PIN_INFOBOX)) {
        _registerMarker(marker, content);
        _updateInfoBoxState();
      }
    });

    // Unregister the marker the cursor rolled out of.
    google.maps.event.addListener(marker, 'mouseout', function() {
      _infoBoxState.turnOff(OVER_MARKER);
      _infoBoxState.turnOff(OVER_SPIDERFY_MARKER);
      _updateInfoBoxState();
    });

    // When user clicks the marker, open the infoBox
    // and center the map on the marker,
    // unless the user clicked a marker that just spiderfied.
    google.maps.event.addListener(marker, 'click', function() {

      // Touch displays don't know they're over a marker till it's tapped,
      // so manually register the state as being over the marker in this case.
      if (_infoBoxState.isOn(IS_TOUCH))
        _registerMarker(marker, content);

      if (_infoBoxState.isOn(HAS_SPIDERFIED)) {
        _infoBoxState.turnOff(HAS_SPIDERFIED);
      }
      else if (_infoBoxState.isOn(PIN_INFOBOX)){
        _turnOffInfoBoxStates();
        _updateInfoBoxState(0);
      }
      else {
        _map.panTo(marker.position);
        _infoBoxState.turnOn(PIN_INFOBOX);
        _infoBoxState.turnOn(OVER_MARKER);
        _infoBoxState.turnOff(OVER_SPIDERFY_MARKER);
        _updateInfoBoxState(0);
      }
    });
  }

  // Whether a map marker is a spiderfy marker.
  // @param marker [Object] a map marker.
  // @return [Boolean] true if the marker is spiderfied, false otherwise.
  function _isSpiderfyMarker(marker) {
    var manager = marker.manager;
    return manager.isOn(manager.SPIDERFIED_ICON);
  }

  // Register a marker as having been clicked.
  // @param marker [Object] The marker that was clicked.
  // @param content [String] The text content of the infobox for this marker.
  function _registerMarker(marker, content) {
    _overMarker = marker;
    if (_isSpiderfyMarker(marker))
      _infoBoxState.turnOn(OVER_SPIDERFY_MARKER);
    else
      _infoBoxState.turnOn(OVER_MARKER);

    _infoBoxState.turnOff(OVER_INFOBOX);
    _infoBoxState.turnOff(SHOW_INFOBOX);
    _infoBoxState.turnOff(PIN_INFOBOX);

    _infoBoxContent = content;
  }

  // Triggers a resize event and refits the map to the bounds of the markers.
  function _refresh() {
    google.maps.event.trigger(_map, 'resize');
    _map.fitBounds(_markerBounds);
  }

  return {
    init:init
  };
});
