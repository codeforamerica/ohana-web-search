// Provides a upgrade notice that can be shown to outdated browsers (e.g. IE8).
define([
  'util/cookie',
  'app/alert-manager'
],
function (cookie, alert) {
  'use strict';

  // Show upgrade notice if browser-upgrade-notice cookie isn't set.
  function show() {
    if (cookie.read('browser-upgrade-notice') === null) {
      var notice = "<i class='fa fa-exclamation-triangle'></i> " +
                   'Your browser is out-of-date and has known security issues.' +
                   '<br />' +
                   "<a href='https://browser-update.org/update.html'>" +
                   'Please visit this page to download an up-to-date browser.' +
                   '</a>';
      alert.addEventListener('close', _alertClosed);
      alert.show(notice, alert.type.INFO);
    }
  }

  // Create a cookie when the alert is closed that will hide the alert for the next day.
  function _alertClosed() {
    cookie.create('browser-upgrade-notice', 'true', true, 1);
  }

  return {
    show:show
  };
});
