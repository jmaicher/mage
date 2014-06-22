"use strict"

module = angular.module('mage.mobile.product_backlog', ['mage.hosts'])

module.config ($routeProvider) ->
  $routeProvider
    .when '/product-backlog',
      templateUrl: "/views/product_backlog.html"
      controller: 'ProductBacklogCtrl'
      resolve:
        backlog: (ProductBacklog) ->
          ProductBacklog.get()


module.service 'ProductBacklogResource', ($resource, Hosts) ->
  ProductBacklogResource = $resource "#{Hosts.api}/backlog"

  ProductBacklogResource
# ProductBacklogResource

module.service 'ProductBacklog', (ProductBacklogResource) ->
  
  get = ->
    ProductBacklogResource.get().$promise

  return {
    get: get
  }
# ProductBacklog

module.controller 'ProductBacklogCtrl', ($rootScope, $scope, backlog) ->
  $rootScope.screenName = "product-backlog"
  $scope.items = backlog.items
# ProductBacklogCtrl


