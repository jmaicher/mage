deps = ['mage.desktop.sprint_planning.sprint_backlog_item_tasks']
module = angular.module('mage.desktop.sprint_planning.sprint_backlog_item', deps)

module.directive 'sprintBacklogItem', ->
  restrict: 'E'
  templateUrl: 'sprint_planning/sprint_backlog_item.html'
  replace: true
  scope:
    sprint: '='
    item: '='
  controller: ($scope) ->

