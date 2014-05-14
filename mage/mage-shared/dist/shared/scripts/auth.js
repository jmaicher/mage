(function() {
  "use strict";
  var module;

  module = angular.module('mage.auth', ['mage.session']);

  module.config(function($httpProvider) {
    return $httpProvider.interceptors.push('authInterceptors');
  });

  module.run(function($rootScope, $location, AuthConfig, SessionService) {
    return $rootScope.$watch((function() {
      return $location.path();
    }), function(newPath, oldPath) {
      if (!SessionService.isAuthenticated() && newPath !== AuthConfig.getSignInPath()) {
        return $location.search({
          redirect_to: newPath
        }).path('/auth');
      }
    });
  });

  module.provider('AuthConfig', function() {
    var sign_in_path;
    sign_in_path = '/auth';
    this.setSignInPath = function(path) {
      return sign_in_path = path;
    };
    this.$get = function() {
      return {
        getSignInPath: function() {
          return sign_in_path;
        }
      };
    };
  });

  module.provider('authInterceptors', function() {
    this.$get = [
      '$location', '$q', 'AuthConfig', 'SessionService', function($location, $q, AuthConfig, SessionService) {
        return {
          request: function(config) {
            if (SessionService.isAuthenticated()) {
              config.headers['API-TOKEN'] = SessionService.getAuthenticable().api_token;
            }
            return config;
          },
          responseError: function(rejection) {
            var redirect_to;
            if (rejection.status === 401) {
              redirect_to = $location.path();
              $location.search({
                redirect_to: redirect_to
              }).path(AuthConfig.getSignInPath());
            }
            return $q.reject(rejection);
          }
        };
      }
    ];
  });

}).call(this);

//# sourceMappingURL=auth.js.map
