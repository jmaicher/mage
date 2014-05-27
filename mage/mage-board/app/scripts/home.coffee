"use strict"

deps = []
module = angular.module('mage.board.home', deps)

# -- Routes ------------------------------------------------------------

module.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/views/home.html',
      controller: 'HomeController'
      resolve:
        reactiveActivities: (MageReactive) ->
          MageReactive.connect('/activities')


# -- Controllers -------------------------------------------------------

module.controller 'HomeController', ($rootScope, $scope, $location, MeetingService, reactiveActivities) ->

  reactiveActivities.on 'meeting.started', (meeting_params) ->
    meeting = MeetingService.from_params(meeting_params)
    $scope.$apply ->
      $rootScope.meeting = meeting
      $location.path "/meetings/#{meeting.model.id}"

# HomeController
