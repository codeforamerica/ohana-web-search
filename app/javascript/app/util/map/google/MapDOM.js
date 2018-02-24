// Sets up the association between the DOM and a Google map.
define(
function () {
  'use strict';

  // @param mapContainerSelector [String] DOM selector for map container.
  // @param mapCanvasSelector [String] DOM selector for map canvas.
  // @return [Object] A MapDOM instance.
  function create(mapContainerSelector, mapCanvasSelector) {
    return new MapDOM(mapContainerSelector, mapCanvasSelector);
  }

  // @param mapContainerSelector [String] DOM selector for map container.
  // @param mapCanvasSelector [String] DOM selector for map canvas.
  // @return [Object] A MapDOM instance.
  function MapDOM(mapContainerSelector, mapCanvasSelector) {
    var _instance = this;

    var _mapContainer = document.querySelector(mapContainerSelector);
    var _mapCanvas = _mapContainer.querySelector(mapCanvasSelector);

    // Initialize a new Google Map.
    function render() {
      if (!_mapContainer || !_mapCanvas)
        throw new Error('DOM elements for map not found!');

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
        maxZoom: 16,
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

      _mapContainer.classList.remove('hide');
      var _map = new google.maps.Map(_mapCanvas, mapOptions);

      _instance.container = _mapContainer;
      _instance.canvas = _mapCanvas;
      _instance.map = _map;

      return _instance;
    }

    _instance.render = render;

    return _instance;
  }

  return {
    create:create
  };
});
