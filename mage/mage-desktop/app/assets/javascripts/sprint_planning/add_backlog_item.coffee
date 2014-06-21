module = angular.module('mage.desktop.sprint_planning.add_backlog_item', [])

module.controller 'sprint_planning.AddBacklogItemCtrl', ($rootScope, $scope, $modalInstance, product_backlog, SprintBacklogItem) ->
  $scope.sprint = $rootScope.currentSprint
  $scope.loading = false
  $scope.items = product_backlog.items

  $scope.select = (item) ->
    $scope.selected_item = if item != $scope.selected_item then item else undefined
  
  onSuccess = (item) ->
    $modalInstance.close(item)

  onFailure = (resp) ->
    console.log 'SHIT FUCK'
    console.log resp

  $scope.confirm = ->
    $scope.loading = true
    SprintBacklogItem.create($scope.sprint, $scope.selected_item)
      .then(onSuccess, onFailure)
      .finally ->
        $scope.loading = false

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

