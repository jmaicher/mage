(function() {
  "use strict";
  var module;

  module = angular.module('mage.session', ['ngCookies', 'mage.utils']);

  module.service('SessionService', function($cookieStore, UUID) {
    var authenticable, getAuthenticable, setAuthenticable, uuid;
    authenticable = void 0;
    uuid = UUID.generate();
    authenticable = $cookieStore.get('session');
    setAuthenticable = function(_authenticable) {
      authenticable = _authenticable;
      return $cookieStore.put('session', authenticable);
    };
    getAuthenticable = function() {
      return authenticable;
    };
    return {
      isAuthenticated: function() {
        return !!authenticable;
      },
      getUUID: function() {
        return uuid;
      },
      getAuthenticable: getAuthenticable,
      getUser: getAuthenticable,
      getDevice: getAuthenticable,
      setAuthenticable: setAuthenticable,
      setUser: setAuthenticable,
      setDevice: setAuthenticable
    };
  });

}).call(this);

//# sourceMappingURL=session.js.map
