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
          MeetingService.get(meeting_id)
        backlog_item: ($route, BacklogItemService) ->
          backlog_item_id = $route.current.params.backlog_item_id
          BacklogItemService.get(backlog_item_id)
# module.config

module.controller 'meetings.BacklogItemController', ($scope, meeting, backlog_item) ->
  $scope.item = backlog_item
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
