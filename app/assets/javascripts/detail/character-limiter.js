// Manages limiting the characters of the _description on the
// details page and providing a more/less link to toggle
// showing or hiding excess text.
define(
function () {
  'use strict';

  // 'Constants'
  // How many characters to show
  var SHOW_CHAR = 400;

  // Limit added to SHOW_CHAR if truncated value is less than this value.
  var SOFT_LIMIT = 100;

  // Text for showing/hiding more text.
  var MORE_TEXT = 'more';
  var LESS_TEXT = 'less';

  var _desc;
  var _fulltext;
  var _ellipsestext = '…';

  var _isShowingMore = false;

  function init() {
    _desc = document.querySelector('#detail-info .description span');

    // If _description exists.
    if (_desc) {
      _fulltext = _desc.innerHTML;
      if(_fulltext.length > SHOW_CHAR)
        _showLess();
    }
  }

  function _linkClicked() {
    _isShowingMore = !_isShowingMore;
    if (_isShowingMore)
      _showMore();
    else
      _showLess();
  }

  // Show more text.
  function _showMore() {
    _desc.innerHTML = _fulltext;

    var lnk = document.createElement('a');
    lnk.innerHTML = LESS_TEXT;

    _desc.appendChild(lnk);
    lnk.addEventListener('click', _linkClicked, false);

    return false;
  }

  // Show less text.
  function _showLess() {
    _fulltext = _fulltext.trim();
    var c = _fulltext.substr(0, SHOW_CHAR);
    var h = _fulltext.substr(SHOW_CHAR - 1, _fulltext.length - SHOW_CHAR);

    // if truncated content is less than SOFT_LIMIT, remove truncation.
    if (h.length < SOFT_LIMIT) {
      c += h;
      h = '';
    }

    if (h.length > 0) {
      var lnk = document.createElement('a');
      lnk.innerHTML = MORE_TEXT;

      var html = c + '<span class="moreellipses">' +
                _ellipsestext + '&nbsp;</span><span><span class="hide">' +
                h + '</span></span>';

      _desc.innerHTML = html;
      _desc.appendChild(lnk);
      lnk.addEventListener('click', _linkClicked, false);
    }
  }

  return {
    init:init
  };
});
