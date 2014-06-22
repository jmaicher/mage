"use strict"

module = angular.module('mage.mobile.backlog_item', ['mage.hosts'])

module.config ($routeProvider) ->
  $routeProvider
    .when '/backlog_items/:id',
      templateUrl: "/views/backlog_item.html"
      controller: 'BacklogItemCtrl'
      resolve:
        item: ($route, BacklogItem) ->
          id = $route.current.params.id
          BacklogItem.get(id)


module.service 'BacklogItemResource', ($resource, Hosts) ->
  BacklogItemResource = $resource "#{Hosts.api}/backlog_items/:id", {
    id: '@id'
  }

  BacklogItemResource
# BacklogItemResource

module.service 'BacklogItem', (BacklogItemResource) ->
  
  get = (id) ->
    BacklogItemResource.get(id: id).$promise

  return {
    get: get
  }
# BacklogItem

module.controller 'BacklogItemCtrl', ($rootScope, $scope, item) ->
  $rootScope.screenName = "backlog-item"
  $scope.item = item
# BacklogItemCtrl

