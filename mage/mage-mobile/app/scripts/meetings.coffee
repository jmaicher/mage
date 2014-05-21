"use strict"

meeting = angular.module('mage.mobile.meetings', [
  'mage.mobile.meetings.poker'
])

meeting.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:id',
      templateUrl: '/views/meeting.html'
      controller: 'MeetingController'
      resolve:
        meeting: ($route, MeetingService) ->
          id = $route.current.params.id
          MeetingService.get(id).then (meeting) ->
            meeting.join().then () ->
              return meeting

meeting.controller 'MeetingController', ($rootScope, $scope, meeting, $timeout) ->
  $rootScope.screenName = 'meeting'
  $scope.meeting = meeting

