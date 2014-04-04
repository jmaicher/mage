"use strict"

ideas = angular.module('mageMobile.ideas')

ideas.service 'Idea', ($q, $http) ->

  create = (params) ->
    dfd = $q.defer()
    url = "http://#{window.location.hostname}:3000/api/ideas"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, errors: resp.data)

    $http.post(url, params).then success, failure

    dfd.promise


  return {
    create: create
  }

ideas.controller 'ideas.IndexCtrl', ->
  console.log 'index'

ideas.controller 'ideas.NewCtrl', ($scope, $location, Idea) ->
  
  success = (idea) ->
    $scope.loading = false
    $location.path '/ideas'

  failure = (reason) ->
    $scope.loading = false
    console.log reason.errors
    $scope.errors = reason.errors

  $scope.submit = (params) ->
    $scope.errors = {}
    $scope.ideaForm.$setPristine(true)
    $scope.loading = true
    Idea.create(params).then success, failure

