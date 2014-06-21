#= require_tree ./sprint_planning

deps = ['mage.desktop.sprint_planning.sprint_backlog']
module = angular.module('mage.desktop.sprint_planning', deps)

module.controller 'SprintPlanningController', ($rootScope, Sprint, BootstrappedData) ->
  $rootScope.currentSprint = Sprint.from_json(BootstrappedData.sprint)
