"use strict"

app = angular.module('mage.services', ['mage.mapper', 'mage.hosts'])


app.service 'Random', ->
  getRandomInt: (min, max) ->
    Math.round(Math.random() * (Math.abs(min) + Math.abs(max))) + min


app.service('BacklogService', ($q, $http, Hosts, BacklogMapper) ->
  backlog = undefined

  get = ->
    dfd = $q.defer()
    if backlog
      dfd.resolve(backlog)
      return dfd.promise

    success = (resp) ->
      backlog = BacklogMapper.from_json(resp.data)
      dfd.resolve(backlog)
    
    failure = (reason) ->
      dfd.reject(reason)

    promise = $http.get("#{Hosts.api}/backlog")
      .then(success, failure)

    dfd.promise

  return {
    get: get
  }

)

