(function() {
  var module;

  module = angular.module('mage.meetings', ['mage.hosts']);

  module.service('MeetingService', function($q, $http, Hosts) {
    var create, get;
    get = function(id) {
      var dfd, failure, success, url;
      dfd = $q.defer();
      url = "" + Hosts.api + "/meetings/" + id;
      success = function(resp) {
        return dfd.resolve(resp.data);
      };
      failure = function(resp) {
        return dfd.reject({
          status: resp.status,
          reason: resp.data
        });
      };
      $http.get(url).then(success, failure);
      return dfd.promise;
    };
    create = function() {
      var dfd, failure, success, url;
      dfd = $q.defer();
      url = "" + Hosts.api + "/meetings";
      success = function(resp) {
        return dfd.resolve(resp.data);
      };
      failure = function(resp) {
        return dfd.reject({
          status: resp.status,
          errors: resp.data
        });
      };
      $http.post(url).then(success, failure);
      return dfd.promise;
    };
    return {
      get: get,
      create: create
    };
  });

}).call(this);

//# sourceMappingURL=meetings.js.map
