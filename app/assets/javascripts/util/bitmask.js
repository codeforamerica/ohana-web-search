// Used for a creating and managing a bitmask of binary settings.
// Bitmask bits can be flipped on or off to create a very compact
// list of toggleable settings that are stored in one integer.
define(
function () {
  'use strict';

  var _bitmask = 0;

  function create() {
    return new BitMask();
  }

  function BitMask() {

    function turnOn(state) {
      _bitmask |= state;
    }

    function turnOff(state) {
      _bitmask &= ~state;
    }

    function isOn(state) {
      return !!(_bitmask & state);
    }

    function isOff(state) {
      return !(_bitmask & state);
    }

    return {
      turnOn:turnOn,
      turnOff:turnOff,
      isOn:isOn,
      isOff:isOff
    };
  }

  return {
    create:create
  };
});