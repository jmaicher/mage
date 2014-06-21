"use strict"

deps = [
  'mage.meetings',
  'mage.board.meetings.poker'
  'mage.board.meetings.backlog_items'
]
module = angular.module('mage.board.meetings', deps)

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:id',
      templateUrl: '/views/meeting.html'
      controller: 'MeetingController'
      resolve:
        meeting: ($q, $rootScope, $route, MeetingService) ->
          meeting = undefined
          if $rootScope.meeting
            meeting = $q.when($rootScope.meeting)
            # remove global tmp variable
            delete $rootScope.meeting
          else
            id = $route.current.params['id']
            meeting = MeetingService.get(id)
          
          meeting.then (meeting) ->
            meeting.join().then ->
              meeting.connect()
              return meeting


module.controller 'MeetingController', ($rootScope, $scope, $location, meeting) ->
  
  on_poker_started = (poker) ->
    $scope.$apply ->
      $rootScope.poker = poker
      $location.path "/meetings/#{meeting.model.id}/poker/#{poker.model.id}"

  meeting.on 'poker.started', on_poker_started

  $scope.$on '$destroy', ->
    meeting.off 'poker.started', on_poker_started

