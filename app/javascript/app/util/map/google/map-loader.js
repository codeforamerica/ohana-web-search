// Used for asynchronously loading Google Maps APIs.
import envVars from 'app/util/environmentVariables';

// @param callback [Function]
//   A function to call when the maps scripts have loaded.
function load(callback) {
  var gmaps = new GoogleMaps();
  gmaps.load(callback);
}

function GoogleMaps() {
  // Classlist object of the page's <html> element.
  var _htmlClassList;

  // External callback function to call when the maps scripts have loaded.
  var _callback;

  // Global callback function name to call internally when the maps
  // scripts have loaded.
  var _globalCallbackName;

  function load(callback) {
    _callback = callback;

    _htmlClassList = document.documentElement.classList;
    callback.call();
  }

  return {
    load:load
  };
}

export default {
  load:load
};
