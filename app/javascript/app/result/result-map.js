// Manages search results view Google Map.
import markerDataLoader from 'app/util/map/marker-data-loader';
import googleMaps from 'app/util/map/google/map-loader';
import plugins from 'app/util/map/google/plugins-loader';
import mapRenderer from 'app/util/map/google/map-renderer';
import MapSizeControl from 'app/util/map/MapSizeControl';

// Whether the Google Map APIs and plugins have successfully loaded.
var _mapStackReady = false;

function init() {
  // Load map marker data from DOM.
  var markerData = markerDataLoader.loadData('#map-locations-data');

  // Load Google Maps if there is data to display.
  if (markerData.length > 0) {
    plugins.registerCallback(_pluginsLoaded);
    googleMaps.load(plugins.load);
  }
}

// Google Map plugin modules have successfully loaded.
function _pluginsLoaded() {
  _mapStackReady = true;
  mapRenderer.init('#map-view',
                   '#map-canvas'
                  );
  mapRenderer.renderMapStack();
  var mapSizeControl = MapSizeControl.create('#map-size-control');
  mapSizeControl.addEventListener('click', _mapSizeControlClicked);
}

function _mapSizeControlClicked() {
  mapRenderer.toggleSize();
}

// Re-initializes the map in the DOM, if required APIs have been loaded.
function refresh() {
  if (_mapStackReady)
    mapRenderer.renderMapStack();
}

export default {
  init:init,
  refresh:refresh
};
