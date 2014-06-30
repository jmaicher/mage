"use strict"

meeting = angular.module('mage.mobile.meetings', [
  'mage.mobile.meetings.poker'
  'mage.mobile.backlog_item'
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


meeting.controller 'MeetingController', ($rootScope, $scope, $location, meeting, BacklogItem) ->
  $rootScope.screenName = 'meeting'
  $scope.meeting = meeting.model

  handle_poker_started = (poker) ->
    $scope.$apply ->
      $location.path "/meetings/#{meeting.model.id}/poker/#{poker.model.id}"

  handle_backlog_item_focus = (json_repr) ->
    item = BacklogItem.from_json json_repr
    $scope.$apply ->
      $scope.focusedItem = item

  handle_backlog_item_unfocus = (item) ->
    $scope.$apply ->
      $scope.focusedItem = undefined

  $scope.showBacklogItemDetails = (item) ->
    $rootScope.item = item
    $rootScope.currentMeeting = meeting
    $location.path "/meetings/#{meeting.model.id}/backlog_items/#{item.id}"

  meeting.on 'poker.started', handle_poker_started
  meeting.on 'backlog_item.focus', handle_backlog_item_focus
  meeting.on 'backlog_item.unfocus', handle_backlog_item_unfocus

  $scope.$on '$destroy', ->
    # cleanup
    meeting.off 'poker.started', handle_poker_started
    meeting.off 'backlog_item.focus', handle_backlog_item_focus
    meeting.off 'backlog_item.unfocus', handle_backlog_item_unfocus

