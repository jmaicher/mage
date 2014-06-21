#= require models
#= require backlog_items
#= require sprint_planning

deps = [
  # angular extensions
  'ngResource', 'ui.bootstrap'
  # angular-rails-templates
  'templates'
  # app-specific modules
  'mage.desktop.models',
  'mage.desktop.backlog_items',
  'mage.desktop.sprint_planning'
]

mage = angular.module('mage.desktop', deps)

mage.service 'BootstrappedData', ($window) ->
  $window.BOOTSTRAPPED_DATA

