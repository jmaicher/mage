(function() {
  "use strict";
  var module;

  module = angular.module('mage.session', ['mage.utils']);

  module.service('SessionService', function(UUID) {
    var authenticable, getAuthenticable, setAuthenticable, uuid;
    authenticable = void 0;
    uuid = UUID.generate();
    setAuthenticable = function(_authenticable) {
      return authenticable = _authenticable;
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
