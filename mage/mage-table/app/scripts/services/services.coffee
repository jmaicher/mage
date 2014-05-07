"use strict"

app = angular.module('mage.services', ['mage.mapper'])

mage_table_host = window.location.host
mage_web_host = mage_table_host.substr(mage_table_host.indexOf('.') + 1)

app.constant 'mageWeb',
  api: "http://#{mage_web_host}/api"


app.service 'Random', ->
  getRandomInt: (min, max) ->
    Math.round(Math.random() * (Math.abs(min) + Math.abs(max))) + min


app.service('BacklogService', ($q, $http, mageWeb, BacklogMapper) ->
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

    promise = $http.get("#{mageWeb.api}/backlog")
      .then(success, failure)

    dfd.promise

  return {
    get: get
  }

)

