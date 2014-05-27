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
            meeting.join().then ->
              meeting.connect().then ->
                meeting


meeting.controller 'MeetingController', ($rootScope, $scope, $location, meeting) ->
  $rootScope.screenName = 'meeting'
  $scope.meeting = meeting.model

  handle_poker_started = (poker) ->
    console.log 'poker started'
    $scope.$apply ->
      $location.path "/meetings/#{meeting.model.id}/poker/#{poker.model.id}"

  meeting.on 'poker.started', handle_poker_started

  $scope.$on '$destroy', ->
    # cleanup
    meeting.off 'poker.started', handle_poker_started

