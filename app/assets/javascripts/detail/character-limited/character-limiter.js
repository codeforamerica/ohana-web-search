// Finds elements that have the 'character-limited' class assigned to them
// and adds a new CharacterLimited instance to those elements.
define([
  'detail/character-limited/CharacterLimited'
],
function (CharacterLimited) {
  'use strict';

  // 'Constants'
  // How many characters to show.
  var SHOW_CHAR = 400;

  // Limit added to SHOW_CHAR if truncated value is less than this value.
  var SOFT_LIMIT = 100;

  // Text for showing/hiding more text.
  var MORE_TEXT = '<span><</span>more<span>></span>';
  var LESS_TEXT = '<span><</span>less<span>></span>';
  var ELLIPSES_TEXT = '…';

  function init() {
    var defaults = {
      SHOW_CHAR:SHOW_CHAR,
      SOFT_LIMIT:SOFT_LIMIT,
      MORE_TEXT:MORE_TEXT,
      LESS_TEXT:LESS_TEXT,
      ELLIPSES_TEXT:ELLIPSES_TEXT
    };
    var charLimitedElms = document.querySelectorAll('.character-limited');
    var numberElms = charLimitedElms.length;
    while( numberElms > 0 )
      CharacterLimited.create(charLimitedElms[--numberElms], defaults);
  }

  return {
    init:init
  };
});
