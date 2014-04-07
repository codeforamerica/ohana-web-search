// interface for interacting with web storage (local storage and session storage).
// A final parameter of true on all methods specifies to use session storage
// (non-persistant storage). A final parameter of false on all methods specifies to use
// local storage (persistent storage). E.g. webStorageProxy.setItem("name","Anselm",true)
// for session storage or webStorageProxy.getItem("name") for local storage (note omitted
// 'true' value).
// Note that values stored in local storage are not accessible from session storage and
// vice versa. They both work on different objects within the browser.
define(function() {
  'use strict';

  // set an item value specified by the key. Returns the value.
  function setItem(key, value, sessionOnly) {
    var storage = _sessionOrLocal(sessionOnly);
    storage.setItem(key,value);
    return value;
  }

  // get an item specified by the key. Returns null if the item has no value.
  function getItem(key, sessionOnly) {
    var storage = _sessionOrLocal(sessionOnly);
    return storage.getItem(key);
  }

  // remove an item specified by the key. Returns true if the item existed and it was
  // removed. Returns false if the item didn't exist to begin with.
  function removeItem(key, sessionOnly) {
    var storage = _sessionOrLocal(sessionOnly);
    var returnVal = true;
    if (!storage.getItem(key)) returnVal = false;
    if (returnVal) storage.removeItem(key);

    return returnVal;
  }

  // internal function for whether to use local or session storage.
  function _sessionOrLocal(sessionOnly)
  {
    var storage;
    (sessionOnly) ? storage = sessionStorage : storage = localStorage;
    return storage;
  }


  return {
    setItem:setItem,
    getItem:getItem,
    removeItem:removeItem
  };
});