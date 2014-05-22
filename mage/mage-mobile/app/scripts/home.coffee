"use strict"

module = angular.module('mage.mobile.home', [
  'mage.meetings'
])

module.config ($routeProvider) ->
  $routeProvider
    .when '/home',
      controller: 'HomeController'
      templateUrl: '/views/home.html'
      resolve:
        meetings: (MeetingService) ->
          MeetingService.current()

module.controller 'HomeController', ($rootScope, $scope, meetings) ->
  $rootScope.screenName = 'home'
  $scope.meetings = meetings.items

