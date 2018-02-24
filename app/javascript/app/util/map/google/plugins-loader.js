// Used for asynchronously loading Google Maps APIs.
define(
function () {
  'use strict';

  // Reference to plugin modules.
  var _plugins = {};

  // External callback function to call when the plugins have loaded.
  var _callback;

  // @param callback [Function]
  //   A function to call when the maps scripts have loaded.
  function registerCallback(callback) {
    _callback = callback;
  }

  // Load the required Google Maps plugins.
  function load() {
    require([
      'gmapsOMS',
      'gmapsInfobox'
    ],
    function (OverlappingMarkerSpiderfier, InfoBox) {
      if (!OverlappingMarkerSpiderfier || !InfoBox)
        throw new Error('Google Maps plugins did not loaded properly!');

      _plugins = {
                  OverlappingMarkerSpiderfier:OverlappingMarkerSpiderfier,
                  InfoBox:InfoBox
                };

      // The plugins have loaded, call the callback function, if registered.
      if (_callback) _callback.call();
    });
  }

  // @return [Object] Hash of Google Maps plugins.
  function getPlugins() {
    return _plugins;
  }

  return {
    registerCallback:registerCallback,
    load:load,
    getPlugins:getPlugins
  };
});
