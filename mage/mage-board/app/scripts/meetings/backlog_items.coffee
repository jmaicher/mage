"use strict"

deps = []
module = angular.module('mage.board.meetings.backlog_items', deps)

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:meeting_id/backlog_items/:backlog_item_id',
      templateUrl: '/views/meetings/backlog_item.html',
      controller: 'meetings.BacklogItemController',
      resolve:
        meeting: ($route, MeetingService) ->
          meeting_id = $route.current.params.meeting_id
          MeetingService.get(meeting_id).then (meeting) ->
            meeting.connect().then -> meeting
        backlog_item: ($route, BacklogItemService) ->
          backlog_item_id = $route.current.params.backlog_item_id
          BacklogItemService.get(backlog_item_id)
# module.config

module.controller 'meetings.BacklogItemController', ($scope, $rootScope, $location, meeting, backlog_item, BacklogItemResource) ->
  $scope.meeting = meeting
  $scope.item = backlog_item

  $scope.$on 'keyup', (evt, keyEvt) ->
    if keyEvt.keyCode == 80 # = p
      $scope.startPlanningPoker()

  $scope.startPlanningPoker = ->
    promise = meeting.start_poker_session(backlog_item)
    $scope.startingPlanningPoker = true
    promise.then (poker) ->
      $rootScope.poker = poker
      $location.path "/meetings/#{meeting.model.id}/poker/#{poker.model.id}"

  handle_backlog_item_unfocus = (unfocused_item) ->
    if unfocused_item.id == backlog_item.id
      $scope.$apply ->
        $location.path "/meetings/#{meeting.model.id}"

  handle_live_update = (update) ->
    return unless update.type == "backlog_item"
    item = new BacklogItemResource(update.entity)
    return unless item.id == $scope.item.id
    $scope.$apply ->
      $scope.item = item

  meeting.on 'backlog_item.unfocus', handle_backlog_item_unfocus
  meeting.on 'live_update', handle_live_update

  $scope.$on '$destroy', ->
    # cleanup
    meeting.off 'backlog_item.unfocus', handle_backlog_item_unfocus
    meeting.off 'live_update', handle_live_update

# meetings.BacklogItemController

# TODO: Extract!
module.service 'BacklogItemResource', ($resource, Hosts) ->
  BacklogItemResource = $resource "#{Hosts.api}/backlog_items/:id", {
    id: '@id'
  }

  BacklogItemResource

module.service 'BacklogItemService', (BacklogItemResource) ->

  get = (id) ->
    BacklogItemResource.get(id: id).$promise

  return {
    get: get
  }
