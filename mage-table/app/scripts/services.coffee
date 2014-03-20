"use strict"

app = angular.module('mageTable')

app.constant 'mageWeb', {
  api: 'http://localhost:3000/api'
}

app.service 'Random', ->
  getRandomInt: (min, max) ->
    Math.round(Math.random() * max - min) + min


app.service 'Backlog', ($q, $http, mageWeb) ->
  backlog = undefined

  return {
    get: ->
      dfd = $q.defer()
      
      dfd.resolve(backlog) if backlog

      success = (resp) ->
        backlog = resp.data
        dfd.resolve(backlog)
      
      failure = (reason) ->
        dfd.reject(reason)

      promise = $http.get("#{mageWeb.api}/backlog")
        .then(success, failure)

      dfd.promise
  }

