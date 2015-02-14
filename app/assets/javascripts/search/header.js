// Handles creating a fixed search header when scrolling.
define([
  'util/util'
],
function (util) {
  'use strict';

  var _header;
  var _offsetY;
  var _floatingContent;

  function init() {
    _header = document.getElementById('floating-results-header');
    if (!_header) throw new Error('Floating header DOM not found!');
    _offsetY = _calculateOffset();
    _floatingContent = _header.querySelectorAll('.floating-content');

    _checkIfFloating();

    // If the URL has a hash, offset the scrolling by the height of the
    // floating header. Also offset scrolling if search container is
    // above search results (it's not floated).
    var scrollOffset;
    if (window.location.hash) {
      scrollOffset = _header.offsetHeight;
      window.scrollTo(0, (window.scrollY - scrollOffset));
    } else if ( (util.getStyle(document.getElementById('search-container'),
                'float') === 'none')
              ) {
      scrollOffset = _calculateOffset();
      window.scrollTo(0, scrollOffset - 1);
    }

    window.addEventListener('scroll', _onScroll, false);
    window.addEventListener('resize', _resizeHandler, true);
  }

  function _resizeHandler() {
    _offsetY = _calculateOffset();
  }

  function _onScroll() {
    _checkIfFloating();
  }

  function _calculateOffset() {
    var isFloating = _header.classList.contains('floating');
    _header.classList.remove('floating');
    var offset = util.getOffset(_header).top;
    if (isFloating)
      _header.classList.add('floating');
    return offset;
  }

  function _checkIfFloating() {
    var c;
    if (window.scrollY >= _offsetY) {
      // Make the header float.
      _header.classList.add('floating');
      for (c in _floatingContent)
        if (_floatingContent[c].classList)
          _floatingContent[c].classList.remove('hide');
    } else {
      // Reset the header position.
      _header.classList.remove('floating');
      for (c in _floatingContent)
        if (_floatingContent[c].classList)
          _floatingContent[c].classList.add('hide');
    }
  }

  return {
    init:init
  };
});
