deps = [
  'mage.desktop.sprint_planning.sprint_backlog_item_task'
]
module = angular.module('mage.desktop.sprint_planning.sprint_backlog_item_tasks', deps)

module.directive 'sprintBacklogItemTasks', ->
  restrict: 'E'
  replace: true
  templateUrl: 'sprint_planning/sprint_backlog_item_tasks.html'
  scope:
    sprint: '='
    item: '='
  controller: ($scope, Task) ->
    sprint = $scope.sprint
    item = $scope.item
    
    $scope.tasks = item.tasks

    $scope.onRemove = (task) ->
      $scope.tasks = $scope.tasks.filter (t) -> t != task

    $scope.addTask = ->
      task = Task.build(sprint, item)
      task.isNew = true
      $scope.tasks.push task

