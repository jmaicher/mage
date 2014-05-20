module = angular.module('mage.meetings', ['mage.hosts'])

module.service 'MeetingService', ($q, $http, Hosts) ->

  get = (id) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/meetings/#{id}"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, reason: resp.data)

    $http.get(url).then success, failure
    
    return dfd.promise
  # get
  
  create = ->
    dfd = $q.defer()
    url = "#{Hosts.api}/meetings"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, errors: resp.data)

    $http.post(url).then success, failure
    
    return dfd.promise
  # create
  
  return {
    get: get
    create: create
  }

# MeetingService

