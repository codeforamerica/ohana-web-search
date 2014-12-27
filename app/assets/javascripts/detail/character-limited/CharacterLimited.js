// Manages limiting the characters of the character limited HTML, such as the
// details page description text, and providing a more/less link to toggle
// showing or hiding excess text.
define(
function () {
  'use strict';

  function create(elm, defaults) {
    return new CharacterLimited(elm, defaults);
  }

  function CharacterLimited(elm, defaults) {

    // The full, unlimited text.
    var _fulltext;

    // The show/hide link Element.
    var _showHideElm;

    // Whether more or less text is showing.
    var _isShowingMore = false;

    // The element to character limit.
    var _elm = elm;

    function showMore() {
      _elm.innerHTML = _fulltext;
      _showHideElm.innerHTML = defaults.LESS_TEXT;

      _elm.appendChild(_showHideElm);
    }

    function showLess() {
      _fulltext = _fulltext.trim();
      var c = _fulltext.substr(0, defaults.SHOW_CHAR);
      var h = _fulltext.substr(defaults.SHOW_CHAR - 1,
                               _fulltext.length - defaults.SHOW_CHAR);

      // If truncated content is less than SOFT_LIMIT, remove truncation.
      if (h.length < defaults.SOFT_LIMIT) {
        c += h;
        h = '';
      }

      if (h.length > 0) {
        _showHideElm.innerHTML = defaults.MORE_TEXT;

        var html = c + '<span class="moreellipses">' +
                  defaults.ELLIPSES_TEXT +
                  '&nbsp;</span><span><span class="hide">' +
                  h + '</span></span>';

        _elm.innerHTML = html;
        _elm.appendChild(_showHideElm);
      }
    }

    function _linkClicked() {
      _isShowingMore = !_isShowingMore;
      if (_isShowingMore)
        showMore();
      else
        showLess();
    }

    function _init() {
      _showHideElm = document.createElement('a');
      _showHideElm.addEventListener('click', _linkClicked, false);
      _fulltext = _elm.innerHTML;
      if(_fulltext.length > defaults.SHOW_CHAR)
        showLess();
    }

    _init();

    return {
      showMore:showMore,
      showLess:showLess
    };
  }

  return {
    create:create
  };
});
