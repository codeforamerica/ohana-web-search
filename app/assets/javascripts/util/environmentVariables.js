// Used for accessing key/value environment variables
// that are embedded in the webpage.
define(
function () {
  'use strict';

  var _envVars = null;

  function init(id) {
    var envVars = document.getElementById(id);
    if (!envVars)
      throw new Error('HTML id for Environment Variables was not found!');

    // Read environment variables JSON.
    _envVars = JSON.parse(envVars.innerHTML);

    // Remove the script element from the DOM.
    envVars.parentNode.removeChild(envVars);
  }

  // @param key [String] The environment variable to look up.
  // @return The value of the supplied environment variable, or undefined
  // if the environment variable is not set.
  function getValue(key) {
    // Lazy initialize the environment variables with a default HTML ID.
    if (_envVars === null)
      init('environment-variables');
    var returnVal = _envVars[key];
    // Set the return value to undefined if it's empty, so returned value is
    // consistent with calls to environment variables that don't exist
    // (it would be an empty string otherwise).
    returnVal = returnVal === '' ? undefined : returnVal;
    return returnVal;
  }

  return {
    init:init,
    getValue:getValue
  };
});