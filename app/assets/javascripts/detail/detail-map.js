// Manages location detail view Google Map.
define([
  'util/map/markers',
  'util/map/google/map-loader',
  'domReady!'
],
function (markers, googleMaps) {
  'use strict';

  function init() {
    googleMaps.load(_renderMap);
  }

  // @param nodes [Array] List of DOM HTMLNodes.
  function _removeDOMNodeList( nodes ) {
    var node;
    for ( var i = 0, len = nodes.length; i < len; i++ ) {
      node = nodes[i];
      node.parentNode.removeChild( node );
    }
  }

  function _renderMap() {
    var mapCanvas = document.getElementById('detail-map-canvas');

    if (mapCanvas) {
      var infoWindow = new google.maps.InfoWindow();
      var titleElm = document.getElementById('detail-map-canvas-title');
      var latElm = document.getElementById('detail-map-canvas-lat');
      var lngElm = document.getElementById('detail-map-canvas-lng');

      // Retrieve marker data from embedded HTML values.
      var title = titleElm.innerHTML.trim();
      var lat = latElm.innerHTML.trim();
      var lng = lngElm.innerHTML.trim();

      // Remove embedded values from the DOM.
      _removeDOMNodeList( [titleElm, latElm, lngElm] );

      var latLng = new google.maps.LatLng(lat, lng);

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
        center: latLng,
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
      var map = new google.maps.Map(mapCanvas, mapOptions);

      var markerProxy = markers.create(markers.GENERIC);
      markerProxy.turnOn(markerProxy.LARGE_ICON);

      var locationOptions = {
          map: map,
          title: title,
          position: latLng,
          icon: markerProxy.getIcon()
        };
      var locationMarker = new google.maps.Marker(locationOptions);

      google.maps.event.addListener(locationMarker, 'click', function () {
        infoWindow.setContent(title);
        infoWindow.open(map, locationMarker);
      });

      map.setZoom(16);
      map.setCenter(locationMarker.getPosition());
    } else {
      console.log('Warning: The detail map container was not found!');
    }
  }

  return {
    init:init
  };
},
function (err) {
  'use strict';
  //The error callback.
  //The err object has a list of modules that failed.
  var failedId = err.requireModules && err.requireModules[0];

  console.log('Map failed to load! Hiding map HTML code.', failedId);

  var mapContainer = document.getElementById('map-view');
  mapContainer.classList.add('hide');
});
