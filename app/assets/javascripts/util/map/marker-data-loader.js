// Manages loading of JSON data for Google Maps markers.
define(
function () {
  'use strict';

  // The JSON marker data used on the map.
  var _markerData = [];

  // Load the map marker JSON data for Google Maps.
  // @param mapDataSelector [String] DOM reference to map marker JSON data
  //   encapsulated in a <script> element.
  // @return [JSON] JSON object of map marker data, or an empty array.
  function loadData(mapDataSelector) {
    var locations = document.querySelector(mapDataSelector);
    if (locations) {
      // Load the map marker data from the JSON map data embedded in the DOM.
      _markerData = JSON.parse(locations.innerHTML);

      // Remove the script element from the DOM
      locations.parentNode.removeChild(locations);
    }
    return _markerData;
  }

  // @return [JSON] JSON object of map marker data, or an empty array.
  function getData() {
    return _markerData;
  }

  return {
    loadData:loadData,
    getData:getData
  };
});
