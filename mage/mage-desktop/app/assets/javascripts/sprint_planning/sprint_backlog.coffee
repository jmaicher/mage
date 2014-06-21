deps = [
  'mage.desktop.sprint_planning.sprint_backlog_item'
  'mage.desktop.sprint_planning.add_backlog_item'
]
module = angular.module('mage.desktop.sprint_planning.sprint_backlog', deps)

module.directive 'sprintBacklog', ->
  restrict: 'E'
  templateUrl: 'sprint_planning/sprint_backlog.html'
  controller: ($rootScope, $scope, $modal) ->
    $scope.sprint = $rootScope.currentSprint
    $scope.sprint_backlog = $scope.sprint.backlog
    $scope.items = $scope.sprint_backlog.items

    $scope.add_product_backlog_item = ->
      modal = $modal.open(
        templateUrl: 'sprint_planning/add_backlog_item_modal.html'
        controller: 'sprint_planning.AddBacklogItemCtrl'
        resolve:
          product_backlog: (ProductBacklog) ->
            ProductBacklog.get()
      )

      modal.result.then (item) ->
        $scope.items.push(item)

