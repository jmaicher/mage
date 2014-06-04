#= require backlog_items

deps = [
  # angular extensions
  'ngResource'
  # angular-rails-templates
  'templates'
  # app-specific modules
  'mage.desktop.backlog_items'
]

mage = angular.module('mage.desktop', deps)

mage.service 'BootstrappedData', ($window) ->
  $window.BOOTSTRAPPED_DATA

