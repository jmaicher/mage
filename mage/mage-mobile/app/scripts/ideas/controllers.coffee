"use strict"

ideas = angular.module('mage.mobile.ideas')

ideas.service 'Idea', ($q, $http, Hosts) ->

  all = ->
    dfd = $q.defer()
    url = "#{Hosts.api}/ideas"

    success = (resp) -> dfd.resolve(resp.data)
    failure = (resp) -> dfd.reject()

    $http.get(url).then success, failure

    dfd.promise

  create = (params) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/ideas"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, errors: resp.data)

    $http.post(url, params).then success, failure

    dfd.promise


  return {
    all: all
    create: create
  }


ideas.controller 'ideas.IndexCtrl', ($scope, $rootScope, Idea) ->
  $rootScope.loading = true

  success = (ideasCol) ->
    $rootScope.loading = false
    $scope.ideas = ideasCol.items

  failure = ->
    $rootScope.loading = false

  Idea.all().then success, failure


ideas.controller 'ideas.NewCtrl', ($scope, $location, Idea) ->
  
  success = (idea) ->
    $scope.loading = false
    $location.path '/ideas'

  failure = (reason) ->
    $scope.loading = false
    $scope.errors = reason.errors

  $scope.submit = (params) ->
    $scope.errors = {}
    $scope.ideaForm.$setPristine(true)
    $scope.loading = true
    Idea.create(params).then success, failure

