"use strict"

module = angular.module('mage.mobile.backlog_item', ['mage.hosts'])

item_resolver = ($rootScope, $route, BacklogItem) ->
  item_or_promise = undefined
  if $rootScope.item || $rootScope.currentBacklogItem
    item_or_promise = $rootScope.item || $rootScope.currentBacklogItem
    delete $rootScope.item
    delete $rootScope.currentBacklogItem
  else
    id = $route.current.params.id
    item_or_promise = BacklogItem.get(id)
 
  item_or_promise

meeting_resolver = ($rootScope, $route, MeetingService) ->
  meeting_or_promise = undefined
  if $rootScope.currentMeeting
    meeting_or_promise = $rootScope.currentMeeting
    delete $rootScope.currentMeeting
  else
    id = $route.current.params.meeting_id
    meeting_or_promise = MeetingService.get(id).then (meeting) ->
      meeting.join().then ->
        meeting.connect().then ->
          meeting

  meeting_or_promise

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:meeting_id/backlog_items/:id/edit',
      templateUrl: '/views/backlog_items/edit.html'
      controller: 'EditBacklogItemCtrl'
      resolve:
        meeting: meeting_resolver
        item: item_resolver
    .when '/backlog_items/:id',
      templateUrl: '/views/backlog_item.html'
      controller: 'BacklogItemCtrl'
      resolve:
        meeting: -> undefined
        item: item_resolver
    .when '/meetings/:meeting_id/backlog_items/:id',
      templateUrl: '/views/backlog_item.html'
      controller: 'BacklogItemCtrl'
      resolve:
        meeting: meeting_resolver
        item: item_resolver
    .when '/backlog_items/:id/edit',
      templateUrl: '/views/backlog_items/edit.html'
      controller: 'EditBacklogItemCtrl'
      resolve:
        meeting: -> undefined
        item: item_resolver


module.service 'BacklogItemResource', ($resource, Hosts) ->
  BacklogItemResource = $resource "#{Hosts.api}/backlog_items/:id", {
    id: '@id'
  }, {
    update: {
      method: 'PUT'
    }
  }

  BacklogItemResource
# BacklogItemResource


module.service 'BacklogItem', (BacklogItemResource) ->
  
  get = (id) ->
    BacklogItemResource.get(id: id).$promise

  from_json = (json_attr) ->
    new BacklogItemResource(json_attr)

  return {
    get: get
    from_json: from_json
  }
# BacklogItem


module.controller 'BacklogItemCtrl', ($rootScope, $scope, $location, $route, item, meeting) ->
  isLive = $scope.isLive = !!meeting
  screenName = 'backlog-item'
  screenName = "#{screenName} live" if isLive
  $rootScope.screenName = screenName

  $scope.attachNote = ->
    $rootScope.currentBacklogItem = item
    path = "/backlog_items/#{item.id}/notes/new"
    if isLive
      $rootScope.currentMeeting = meeting
      path = "/meetings/#{meeting.model.id}#{path}"

    $location.path path

  $scope.back = ->
    back_path = undefined
    unless meeting
      back_path = "/product-backlog"
    else
      $scope.currentMeeting = meeting
      back_path = "/meetings/#{meeting.model.id}"

    $location.path back_path
  # back

  $scope.edit = ->
    $rootScope.currentBacklogItem = item
    edit_path = "backlog_items/#{item.id}/edit"
    if meeting
      $rootScope.currentMeeting = meeting
      edit_path = "meetings/#{meeting.model.id}/#{edit_path}"
    $location.path "/#{edit_path}"
  # edit

  $scope.item = item
# BacklogItemCtrl


module.controller 'EditBacklogItemCtrl', ($rootScope, $scope, $location, item, meeting) ->
  screenName = 'edit-backlog-item'
  screenName = "#{screenName} live" if meeting
  $rootScope.screenName = screenName
  
  $scope.live_update = ->
    meeting.live_update 'backlog_item', item

  $scope.cancel = $scope.back = ->
    $rootScope.item = item
    back_path = "backlog_items/#{item.id}"
    if meeting
      $rootScope.currentMeeting = meeting
      back_path = "meetings/#{meeting.model.id}/#{back_path}"
    $location.path "/#{back_path}"
  # cancel
  
  on_success = ->
    $scope.back()

  on_failure = (resp) ->
    $scope.errors = resp.data

  $scope.submit = (item) ->
    $scope.errors = {}
    $scope.backlogItemForm.$setPristine(true)
    $scope.loading = true
    
    params = {}
    params.meeting_id = meeting.model.id if meeting
    item.$update(params).then(on_success, on_failure)
      .finally -> $scope.loading = false

  $scope.item = item
# EditBacklogItemCtrl

