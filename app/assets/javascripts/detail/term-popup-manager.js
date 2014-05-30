// manages behavior of popups
define(function() {
  'use strict';

  // PRIVATE PROPERTIES
  var popups; // array of popups on the page
  var lastPopup; // the last popup to be shown

  // PUBLIC METHODS
  function init()
  {
    popups = document.querySelectorAll(".term-popup-container");

    for (var p=0; p < popups.length; p++)
    {
      var popup = popups[p].firstElementChild;
      var term = popups[p].lastElementChild;
      if ((/\S/.test(popup.textContent)))
      {
        term.addEventListener("mousedown", _popupHandler, false);
        term.classList.add('active');
      }
    }
  }

  // PRIVATE METHODS
  function _popupHandler(evt)
  {
    var thisPopup = (evt.target).parentElement.firstElementChild;
    if (lastPopup && lastPopup !== thisPopup) lastPopup.classList.add("hide");
    lastPopup = thisPopup;
    lastPopup.classList.toggle("hide");
    lastPopup.style.top = (lastPopup.offsetHeight*-1)+"px";
    document.getElementById("content").addEventListener("mousedown", _closeHandler, true);
  }

  function _closeHandler(evt)
  {
    if (evt.target.attributes["href"] === undefined && !evt.target.classList.contains("popup-term"))
    {
      lastPopup.classList.add("hide");
      document.removeEventListener("mousedown", _closeHandler, true);
      document.getElementById("content").removeEventListener("mousedown", _closeHandler, true);
    }
  }

  return {
    init:init
  };
});