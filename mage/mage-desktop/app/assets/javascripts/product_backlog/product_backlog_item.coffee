deps = []
module = angular.module('mage.desktop.product_backlog.product_backlog_item', deps)

module.directive 'productBacklogItem', ->
  restrict: 'E'
  templateUrl: 'product_backlog/product_backlog_item.html'
  replace: true
  scope:
    item: '='
  controller: ($scope) ->

