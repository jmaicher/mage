#= require filter
#= require models
#= require backlog_items
#= require product_backlog
#= require sprint_planning

deps = [
  # angular extensions
  'ngResource', 'ui.bootstrap',
  # angular-rails-templates
  'templates',
  # app-specific modules
  'mage.desktop.filter',
  'mage.desktop.models',
  'mage.desktop.backlog_items',
  'mage.desktop.product_backlog'
  'mage.desktop.sprint_planning'
]

mage = angular.module('mage.desktop', deps)

mage.service 'BootstrappedData', ($window) ->
  $window.BOOTSTRAPPED_DATA


$(document).ready ->

  $(".fancybox").fancybox
    helpers:
      title:
        type: 'float'
