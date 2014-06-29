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

  on_backlog_item_focus = (item) ->
    $scope.$apply ->
      $location.path "/meetings/#{meeting.model.id}/backlog_items/#{item.id}"

  meeting.on 'backlog_item.focus', on_backlog_item_focus
  
  $scope.$on '$destroy', ->
    # This is important! If not done, the ctrl reference will not be freed
    # as the meeting instance holds a reference to it
    meeting.off 'backlog_item.focus', on_backlog_item_focus

