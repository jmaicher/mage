module = angular.module('mage.meetings', ['ngResource', 'mage.hosts'])


module.service 'MeetingParticipationResource', ($resource, Hosts) ->
  MeetingParticipationResource = $resource "#{Hosts.api}/meetings/:meeting_id/participations/:id", {
    meeting_id: '@meeting_id'
    id: '@id'
  }

  return MeetingParticipationResource
    

module.service 'MeetingResource', ($resource, Hosts, MeetingParticipationResource) ->
  MeetingResource = $resource "#{Hosts.api}/meetings/:id", id: '@id', {
    query: {
      method: 'GET',
      isArray: false,
      transformResponse: (data, header) ->
        wrapped = angular.fromJson(data)
        angular.forEach wrapped.items, (item, idx) ->
          wrapped.items[idx] = new MeetingResource(item)
        return wrapped
    }
  }

  MeetingResource.prototype.getName = ->
    if @name != "" then @name
    else "Meeting @ #{@initiator.name}"

  MeetingResource.prototype.join = ->
    participation = new MeetingParticipationResource meeting_id: @id
    participation.$save()
  
  return MeetingResource


module.service 'MeetingService', ($q, $http, Hosts, MeetingResource) ->

  current = ->
    MeetingResource.query().$promise
  # current

  get = (id) ->
    MeetingResource.get(id: id).$promise
  # get
  
  create = (params) ->
    meeting = new MeetingResource(params)
    meeting.$save()
  # create
  
  return {
    current: current
    get: get
    create: create
  }

# MeetingService

