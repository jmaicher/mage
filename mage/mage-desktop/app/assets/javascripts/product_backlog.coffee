#= require_tree ./product_backlog

deps = [
  'mage.desktop.product_backlog.product_backlog_item',
  'mage.desktop.product_backlog.dragdrop'
]
module = angular.module('mage.desktop.product_backlog', deps)

module.controller 'ProductBacklogController', ($rootScope, $scope, ProductBacklog, BootstrappedData) ->
  productBacklog = $rootScope.productBacklog = ProductBacklog.from_json(BootstrappedData.product_backlog)


module.directive 'productBacklog', ->
  restrict: 'E'
  templateUrl: 'product_backlog/product_backlog.html'
  replace: true
  scope:
    productBacklog: '='
    searchQuery: '='
  controller: ($scope) ->
    $scope.prioritizedItems = $scope.productBacklog.prioritizedItems()
    $scope.unprioritizedItems = $scope.productBacklog.unprioritizedItems()
    $scope.dragdropEnabled = true

    # FIXME: Relying on the index is probably EVIL, but I've to get things done right now, sorry :-)
    getPriorityFromIndex = (idx) ->
      # priority starts at 1, index at 0 => + 1
      idx + 1

    $scope.prioritizedDragDropHandler = {
      onItemMoved: (item, idx, oldIdx) ->
        priority = getPriorityFromIndex(idx)
        $scope.productBacklog.insertAt(item.id, priority).then (resp) ->
      onItemRemoved: (item, idx) ->
      onItemInserted: (item, idx) ->
        priority = getPriorityFromIndex(idx)
        $scope.productBacklog.insertAt(item.id, priority).then (resp) ->

    }

    $scope.unprioritizedDragDropHandler = {
      onItemMoved: (item, idx, oldIdx) ->
      onItemRemoved: (item, idx) ->
      onItemInserted: (item, idx) ->
        priority = undefined
        $scope.productBacklog.insertAt(item.id, priority).then (resp) ->
    }

