// manages results maps view
define(['async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback',
         'domReady!'],function () {
  'use strict';

  // PRIVATE PROPERTIES
  var _map; // the map div that the Google map loads into
  var _mapCanvas; // the parent element of _map
  var _mapViewControl; // the element that controls the expanding/contracting of the map
  var _atMaxSize = false; // whether the map is at its max size or not

  var _markerData; // markers on the map
  var _markersArray = []; // array for storing markers
  var _markerBounds; // the bounds of the markers

  // constants for map button text content
  var LARGER_MAP_TEXT = "<i class='fa fa-minus-square'></i> Unzoom map";
  var SMALLER_MAP_TEXT = "<i class='fa fa-plus-square'></i> Zoom map";

  var _infoWindow; // info window to pop up on roll over

  // PUBLIC METHODS
  function init()
  {
    var noResults = document.querySelector("#results-entries .no-results");
    // only check for result map if the page isn't showing no results
    if (!noResults)
    {
      var mapContainer = document.getElementById('map-view');
      if (mapContainer)
      {
        _mapCanvas = document.getElementById("map-canvas");
        _mapViewControl = document.getElementById('map-view-control');
        _mapViewControl.innerHTML = SMALLER_MAP_TEXT;

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
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        _map = new google.maps.Map(_mapCanvas, mapOptions);

        _infoWindow = new google.maps.InfoWindow();
        _infoWindow.setOptions( {disableAutoPan : true} );

        _mapViewControl.addEventListener('click', _mapViewControlClicked, false);

        _loadMarkers();
        _refresh();
      }
      else
      {
        console.log("Warning: The result map container was not found!");
      }
    }
  }

  // map view control clicked
  function _mapViewControlClicked(evt)
  {
    if (_atMaxSize)
    {
      _mapCanvas.classList.remove('max');
      _mapViewControl.innerHTML = SMALLER_MAP_TEXT;
      _atMaxSize = false;
    }
    else
    {
      _mapCanvas.classList.add('max');
      _mapViewControl.innerHTML = LARGER_MAP_TEXT;
      _atMaxSize = true;
    }
    _refresh();

    evt.preventDefault();
  }

  // loads markers
  function _loadMarkers()
  {
    var locations = document.getElementById("map-locations");
    if (locations)
    {
      _markerData = JSON.parse(locations.innerHTML);
      locations.parentNode.removeChild(locations); // remove script element
      _markerBounds = new google.maps.LatLngBounds();

      _clearMarkers();

      var dataLength = _markerData.length;
      for(var m = 0; m<dataLength-1; m++)
      {
        _loadMarker( _markerData[m] );
      }
      var metadata = _markerData[dataLength-1];
      var summaryText = "<span>"+metadata.count+" of "+metadata.total+" results located!</span>";
    }
    else
    {
      // no entries found
      _clearMarkers();
    }
  }

  // clears all markers
  function _clearMarkers()
  {
    for (var i = 0; i < _markersArray.length; i++ ) {
      _markersArray[i].setMap(null);
    }
    _markersArray = [];
  }

  // load a single marker
  function _loadMarker(markerData)
  {
    if (markerData['coordinates'] && markerData['coordinates'][0] && markerData['coordinates'][1])
    {
      var myLatlng = new google.maps.LatLng(markerData['coordinates'][1],markerData['coordinates'][0]);

      var markerIcon = '/assets/markers/human_services.png';

      var marker = new google.maps.Marker({
        id: markerData['id'],
        map: _map,
        title: markerData['name'],
        position: myLatlng,
        icon: markerIcon
      });

      _markersArray.push(marker);

      var agency = markerData['agency'] ? "<h2>"+markerData['agency']+"</h2>" : "";
      var content = "<h1>"+markerData['name']+"</h1>"+agency+
      "<p>Click map <img src='"+markerIcon+"'/> to view details</a></p>";
      _makeInfoWindowEvent(_map, _infoWindow, content, marker);

      google.maps.event.addListener(marker, 'click', _markerClickedHandler);

      _markerBounds.extend(myLatlng);

    }
  }

  // set the content in the info window
  function _makeInfoWindowEvent(map, infowindow, contentString, marker) {
    google.maps.event.addListener(marker, 'mouseover', function() {
      _infoWindow.setContent(contentString);
      _infoWindow.open(map, marker);
    });
  }

  // a location marker was clicked, perform a search for the organization details
  function _markerClickedHandler(evt)
  {
    window.location.href = '/organizations/'+this.id+(window.location.search);
  }

  // Triggers a resize event and refits the map to the bounds of the markers
  function _refresh()
  {
    google.maps.event.trigger(_map, "resize");
    if (_markersArray.length > 0)
      _map.fitBounds(_markerBounds);
  }

  return {
    init:init
  };

});
