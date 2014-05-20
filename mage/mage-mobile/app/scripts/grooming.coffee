"use strict"

grooming = angular.module('mage.mobile.grooming', [
  'mage.mobile.grooming.poker'
])

grooming.config ($routeProvider) ->
  $routeProvider
    .when '/grooming/:id',
      templateUrl: '/views/grooming.html'
      controller: 'GroomingController'

grooming.controller 'GroomingController', ($rootScope, $scope) ->
  $rootScope.screenName = 'grooming'

