module = angular.module('mage.desktop.sprint_planning.sprint_backlog_item_task', [])

module.directive 'sprintBacklogItemTask', ->
  restrict: 'E'
  replace: true
  templateUrl: 'sprint_planning/sprint_backlog_item_task.html'
  scope:
    sprint: '='
    item: '='
    task: '='
    notifyRemoval: '&onRemove'
  link: (scope, element) ->
    scope.remove = ->
      element.remove()
      scope.notifyRemoval()
    return
  controller: ($scope) ->
    $scope.isNew = !!$scope.task.isNew
    delete $scope.task.isNew if $scope.isNew

    $scope.editMode = $scope.isNew

    $scope.edit = ->
      $scope.editMode = true

    $scope.onFormSuccess = ->
      $scope.editMode = false
      $scope.isNew = false

    $scope.onFormCancel = ->
      $scope.editMode = false
      $scope.remove() if $scope.isNew
      return
# sprintBacklogItemTask


module.directive 'sprintBacklogItemTaskForm', ->
  restrict: 'E'
  replace: true
  templateUrl: 'sprint_planning/sprint_backlog_item_task_form.html'
  scope:
    sprint: '='
    item: '='
    master: '=task'
    isNew: '='
    notifySuccess: '&onSuccess'
    notifyCancel: '&onCancel'
  controller: ($scope) ->
    $scope.task = angular.copy($scope.master)

    onSuccess = (task) ->
      # update master => propagate changes to parent scope
      angular.extend $scope.master, task
      $scope.notifySuccess()

    onFailure = (response) ->
      console.log(response.data)
      $scope.errors = response.data

    $scope.submit = ->
      $scope.errors = undefined
      $scope.taskForm.$setPristine(true)
      method = if $scope.isNew then '$save' else '$update'

      $scope.loading = true
      # TODO: Attach these to model during construction
      $scope.task.sprint_id = $scope.sprint.id
      $scope.task.backlog_item_id = $scope.item.id

      $scope.task[method]().then(onSuccess, onFailure)
        .finally -> $scope.loading = false

    $scope.cancel = ->
      $scope.notifyCancel()
# sprintBacklogItemTaskForm

