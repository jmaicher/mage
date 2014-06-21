#= require_tree ./models

deps = [
  'mage.desktop.models.product_backlog'
  'mage.desktop.models.sprint'
  'mage.desktop.models.sprint_backlog'
]

angular.module('mage.desktop.models', deps)
