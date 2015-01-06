// Manages search results view Google Map.
define([
  'util/map/markers',
  'util/map/marker-data-loader',
  'util/map/google/plugins-loader',
  'util/map/google/MapDOM',
  'util/map/google/infobox-manager',
  'domReady!'
],
function (markers, markerDataLoader, plugins, MapDOM, infoBoxManager) {
  'use strict';

  // Module instance with map DOM and google.maps.Map instance references.
  var _mapDOM;

  // Whether the map is at its max size or not.
  var _atMaxSize = false;

  // The collective map bounds of the markers.
  var _markerBounds;

  // The spiderfier layer for handling overlapping markers.
  // See https://github.com/jawj/OverlappingMarkerSpiderfier
  var _spiderfier;

  // The marker the cursor is currently over.
  var _overMarker;

  // @param mapContainerSelector [String] DOM selector for the map container.
  // @param mapCanvasSelector [String] DOM selector for the map canvas.
  function init(mapContainerSelector, mapCanvasSelector) {
    _mapDOM = MapDOM.create(mapContainerSelector, mapCanvasSelector);
  }

  // Run all rendering methods for the map, markers, and info box.
  // Also register events for interactivity.
  function renderMapStack() {
    var allPlugins = plugins.getPlugins();
    _mapDOM.render();
    _renderMarkers(allPlugins.OverlappingMarkerSpiderfier);
    infoBoxManager.render(_mapDOM, allPlugins.InfoBox);
    _registerMapEvents();
    infoBoxManager.registerInfoBoxEvents();
  }

  // Toggle size of map.
  function toggleSize() {
    _atMaxSize = !_atMaxSize;
    if (_atMaxSize)
      _mapDOM.canvas.classList.add('max');
    else
      _mapDOM.canvas.classList.remove('max');

    _updateMarkerSizes();
    _refresh();
  }

  // @param OverlappingMarkerSpiderfier [Object] Marker spiderfier plugin.
  function _renderMarkers(OverlappingMarkerSpiderfier) {
    var spiderfierOptions = {
      legWeight: 2,
      circleFootSeparation: 30,
      keepSpiderfied: true,
      nearbyDistance: 40
    };

    _spiderfier = new OverlappingMarkerSpiderfier(_mapDOM.map,
                                                  spiderfierOptions);

    // Initialize marker bounds.
    _markerBounds = new google.maps.LatLngBounds();

    // Loop over marker data and initialize each marker.
    var markerData = markerDataLoader.getData();
    var index = markerData.length - 1;
    var marker;
    while (index >= 0) {
      marker = _loadMarker(markerData[index--], _atMaxSize, _spiderfier);
    }
    _overMarker = marker;

    _refresh();
  }

  // Load a single map marker.
  // @returns [Object] A google.maps.Marker instance that was created,
  //   or null if there isn't a latitude and longitude in the data.
  function _loadMarker(markerData, atMaxSize, spiderfier) {
    if (!markerData.latitude && !markerData.longitude) return;

    var myLatLng = new google.maps.LatLng(markerData.latitude,
                                          markerData.longitude);

    var markerProxy = markers.create(markers.GENERIC);
    if (atMaxSize)
      markerProxy.turnOn(markerProxy.LARGE_ICON);
    else
      markerProxy.turnOn(markerProxy.SMALL_ICON);

    var markerOptions = {
      map: _mapDOM.map,
      position: myLatLng,
      icon: markerProxy.getIcon(),
      optimized: false,
      manager: markerProxy
    };
    var marker = new google.maps.Marker(markerOptions);

    spiderfier.addMarker(marker);

    var mainName = markerData.name;
    var orgName = markerData.org_name;
    var agency = '';
    if (orgName !== markerData.name)
      agency = '<h2>' + orgName + '</h2>';

    var content = "<div><div class='button-close'></div>" + // jshint ignore:line
                  '<h1>' + mainName + '</h1>' + agency +
                  '<p>' + markerData.street_address + ', ' +
                  markerData.city + '</p>' + "<p><a href='/locations/" + // jshint ignore:line
                  markerData.slug+(window.location.search) +
                  "'>View more details…</a></p></div>"; // jshint ignore:line

    _registerMarkerEvents(marker, content, spiderfier);

    _markerBounds.extend(myLatLng);

    return marker;
  }

  // Register events for map interactivity.
  function _registerMapEvents() {
    google.maps.event.addListener(_mapDOM.map, 'idle', _mapIdle);
    google.maps.event.addListener(_mapDOM.map, 'click', _mapClick);

    _mapDOM.canvas.addEventListener('touchstart', _mapTouch, false);
  }

  // Event handler for when the map is idle. This is used by the spiderfier
  // to style the map markers that will spiderfy when clicked.
  function _mapIdle() {
    _setAllIcons();
    google.maps.event.addListener(_mapDOM.map, 'zoom_changed', _mapZoomed);
    // Remove idle listeners as they aren't needed after the spiderfied markers
    // are styled for the first time.
    google.maps.event.clearListeners(_mapDOM.map, 'idle');
  }

  // Event handler for when the map is zoomed. This is used by the spiderfier
  // to handle style changes to the map markers that will spiderfy when clicked.
  function _mapZoomed() {
    _setAllIcons();
  }

  // Event handler for when the map is clicked. This is used to close
  // any currently open info box.
  function _mapClick() {
    infoBoxManager.turnOffInfoBoxStates();
    infoBoxManager.updateInfoBoxState(_overMarker, 0);
  }

  // Event handler for when a touch event occurs on the map, for
  // changing the interactivity to accommodate lack of mouseover/out events.
  function _mapTouch() {
    infoBoxManager.turnOn(infoBoxManager.STATE.IS_TOUCH);
    _mapDOM.canvas.removeEventListener('touchstart', _mapTouch, false);
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
    while (index >= 0) {
      marker = markers[index--];
      marker.setIcon(marker.manager.getIcon());
    }
  }

  // Make info box events associated with a map marker.
  // @param marker [Object] The marker that triggered the opening of the
  // info box.
  // @param content [String] The text content of the info box.
  // @param spiderfier [Object] The spiderfier plugin instance.
  function _registerMarkerEvents(marker, content, spiderfier) {

    // Change marker icon appearances when the markers spiderfy.
    spiderfier.addListener('spiderfy',
                            function(spiderfied,
                                     unspiderfied) { // jshint ignore:line
      infoBoxManager.turnOn(infoBoxManager.STATE.HAS_SPIDERFIED);
      var index = spiderfied.length - 1;
      while (index >= 0) {
        _setIcon(spiderfied[index--], false);
      }
    });

    // Change marker icon appearances when the markers unspiderfy.
    spiderfier.addListener('unspiderfy',
                            function(spiderfied,
                                     unspiderfied) { // jshint ignore:line
      var index = spiderfied.length - 1;
      while (index >= 0) {
        _setIcon(spiderfied[index--], true);
      }
    });

    // Register the marker the cursor has rolled over.
    google.maps.event.addListener(marker, 'mouseover', function() {
      if (_overMarker !== marker)
        infoBoxManager.turnOff(infoBoxManager.STATE.PIN_INFOBOX);
      if (infoBoxManager.isOff(infoBoxManager.STATE.PIN_INFOBOX)) {
        _registerMarker(marker, content);
        infoBoxManager.updateInfoBoxState(_overMarker);
      }
    });

    // Unregister the marker the cursor rolled out of.
    google.maps.event.addListener(marker, 'mouseout', function() {
      infoBoxManager.turnOff(infoBoxManager.STATE.OVER_MARKER);
      infoBoxManager.turnOff(infoBoxManager.STATE.OVER_SPIDERFY_MARKER);
      infoBoxManager.updateInfoBoxState(_overMarker);
    });

    // When user clicks the marker, open the infoBox
    // and center the map on the marker,
    // unless the user clicked a marker that just spiderfied.
    google.maps.event.addListener(marker, 'click', function() {

      // Touch displays don't know they're over a marker till it's tapped,
      // so manually register the state as being over the marker in this case.
      if (infoBoxManager.isOn(infoBoxManager.STATE.IS_TOUCH))
        _registerMarker(marker, content);

      if (infoBoxManager.isOn(infoBoxManager.STATE.HAS_SPIDERFIED)) {
        infoBoxManager.turnOff(infoBoxManager.STATE.HAS_SPIDERFIED);
      }
      else if (infoBoxManager.isOn(infoBoxManager.STATE.PIN_INFOBOX)){
        infoBoxManager.turnOffInfoBoxStates();
        infoBoxManager.updateInfoBoxState(_overMarker, 0);
      }
      else {
        _mapDOM.map.panTo(marker.position);
        infoBoxManager.turnOn(infoBoxManager.STATE.PIN_INFOBOX);
        infoBoxManager.turnOn(infoBoxManager.STATE.OVER_MARKER);
        infoBoxManager.turnOff(infoBoxManager.STATE.OVER_SPIDERFY_MARKER);
        infoBoxManager.updateInfoBoxState(_overMarker, 0);
      }
    });
  }

  // Whether a map marker is a spiderfied marker.
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
      infoBoxManager.turnOn(infoBoxManager.STATE.OVER_SPIDERFY_MARKER);
    else
      infoBoxManager.turnOn(infoBoxManager.STATE.OVER_MARKER);

    infoBoxManager.turnOff(infoBoxManager.STATE.OVER_INFOBOX);
    infoBoxManager.turnOff(infoBoxManager.STATE.SHOW_INFOBOX);
    infoBoxManager.turnOff(infoBoxManager.STATE.PIN_INFOBOX);

    infoBoxManager.setContent(content);
  }

  // Triggers a resize event and refits the map to the bounds of the markers.
  function _refresh() {
    google.maps.event.trigger(_mapDOM.map, 'resize');
    _mapDOM.map.fitBounds(_markerBounds);
  }

  return {
    init:init,
    renderMapStack:renderMapStack,
    toggleSize:toggleSize
  };
});
