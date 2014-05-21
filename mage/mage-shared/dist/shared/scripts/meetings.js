(function() {
  var module;

  module = angular.module('mage.meetings', ['ngResource', 'mage.hosts']);

  module.service('MeetingParticipationResource', function($resource, Hosts) {
    var MeetingParticipationResource;
    MeetingParticipationResource = $resource("" + Hosts.api + "/meetings/:meeting_id/participations/:id", {
      meeting_id: '@meeting_id',
      id: '@id'
    });
    return MeetingParticipationResource;
  });

  module.service('MeetingResource', function($resource, Hosts, MeetingParticipationResource) {
    var MeetingResource;
    MeetingResource = $resource("" + Hosts.api + "/meetings/:id", {
      id: '@id'
    }, {
      query: {
        method: 'GET',
        isArray: false,
        transformResponse: function(data, header) {
          var wrapped;
          wrapped = angular.fromJson(data);
          angular.forEach(wrapped.items, function(item, idx) {
            return wrapped.items[idx] = new MeetingResource(item);
          });
          return wrapped;
        }
      }
    });
    MeetingResource.prototype.getName = function() {
      if (this.name !== "") {
        return this.name;
      } else {
        return "Meeting @ " + this.initiator.name;
      }
    };
    MeetingResource.prototype.join = function() {
      var participation;
      participation = new MeetingParticipationResource({
        meeting_id: this.id
      });
      return participation.$save();
    };
    return MeetingResource;
  });

  module.service('MeetingService', function($q, $http, Hosts, MeetingResource) {
    var create, current, get;
    current = function() {
      return MeetingResource.query().$promise;
    };
    get = function(id) {
      return MeetingResource.get({
        id: id
      }).$promise;
    };
    create = function(params) {
      var meeting;
      meeting = new MeetingResource(params);
      return meeting.$save();
    };
    return {
      current: current,
      get: get,
      create: create
    };
  });

}).call(this);

//# sourceMappingURL=meetings.js.map
