"use strict"

ideas = angular.module('mageMobile.ideas')

ideas.controller 'ideas.IndexCtrl', ->
  console.log 'index'

ideas.controller 'ideas.NewCtrl', ($scope) ->
  
  $scope.submit = (idea) ->
    console.log idea
