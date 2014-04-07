// manages behavior of results view list vs maps setting
define(['util/web-storage-proxy','map-view-manager'],function(webStorageProxy,mapViewManager) {
  'use strict';

  // PRIVATE PROPERTIES
  var listViewButton;
  var mapViewButton;
  var listView;
  var mapView;
  var selected;

  var storageName = "resultviewpref";

  // PUBLIC METHODS
  function init()
  {
    listView = document.getElementById("list-view");
    mapView = document.getElementById("map-view");

    // check that required views are present on the page
    if (listView && mapView)
    {
      listViewButton = document.getElementById("list-view-btn");
      mapViewButton = document.getElementById("map-view-btn");

      listViewButton.addEventListener( "mousedown" , _listClickHandler , false);
      mapViewButton.addEventListener( "mousedown" , _mapClickHandler , false);

      _updateButtonStates();
    }
  }

  function _updateButtonStates()
  {
    if (webStorageProxy.getItem(storageName) === "map"){
      selected = mapViewButton;
      listViewButton.disabled = "";
    }else{
      selected = listViewButton;
      mapViewButton.disabled = "";
    }

    selected.disabled = "disabled";
    if (selected === listViewButton)
    {
      mapView.classList.add("hide");
      listView.classList.remove("hide");
    }
    else if (selected === mapViewButton)
    {
      listView.classList.add("hide");
      mapView.classList.remove("hide");
      mapViewManager.init();
    }
  }

  // PRIVATE METHODS
  function _listClickHandler(evt)
  {
    webStorageProxy.setItem(storageName , "list");
    _updateButtonStates();
  }

  function _mapClickHandler(evt)
  {
    webStorageProxy.setItem(storageName , "map");
    _updateButtonStates();
  }

  return {
    init:init
  };
});