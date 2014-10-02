// Cookie CRUD functions, from http://www.quirksmode.org/js/cookies.html
// ERB needed to retrieve domain name that the cookie is saved under.
define([
  'util/environmentVariables'
],
function (envVars) {
  'use strict';

  // @param name [String] The cookie's name.
  // @param value [String] The cookie's value.
  // @param useDomain [Boolean] Whether set under subdomains or not.
  // @param days [Number] Number of days till the cookie expires.
  // Can be negative.
  function create(name, value, useDomain, days) {
    var expires = '';
    if (days) {
      var date = new Date();
      date.setTime(date.getTime() + (days*24*60*60*1000));
      expires = '; expires=' + date.toGMTString();
    }

    var setting = name + '=' + value + expires + '; path=/';

    // Set the cookie without the domain parameter.
    document.cookie = setting;
    // Sets the cookie under domain and subdomains
    // (if useDomain parameter is present).
    if (useDomain) {
      var domain = envVars.getValue('DOMAIN_NAME');
      var domainSetting = setting + '; domain=' + domain;
      var subdomainSetting = setting + '; domain=.' + domain;
      document.cookie = domainSetting;
      document.cookie = subdomainSetting;
    }
  }

  // @param name [String] The cookie's name to read.
  // @return [String] The named cookie's value, or null.
  function read(name) {
    var nameEQ = name + '=';
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) === ' ') c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
  }

  // @param name [String] The cookie's name to remove.
  // @param usedDomain [Boolean] Whether to clear subdomains also.
  function erase(name, useDomain) {
    create(name, '', !!useDomain, -1);
  }

  return {
    create:create,
    read:read,
    erase:erase
  };
});
