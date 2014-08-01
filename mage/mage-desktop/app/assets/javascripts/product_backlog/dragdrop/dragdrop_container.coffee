"use strict"

deps = []
module = angular.module('mage.desktop.product_backlog.dragdrop.container', deps)

module.directive 'dragdropContainer', ($parse, dragdropConfig) ->
  restrict: 'A'
  scope: true
  controller: ($scope) ->
    @scope = $scope
    return
  link: (scope, element, attrs) ->
    registerOption = (name) ->
      scope.$watch attrs[name], ->
        scope[name] = $parse(attrs[name])(scope)

    # FIXME: This will not update automatically when the attr changes
    items = $parse(attrs.dragdropContainer)(scope)
    handler = $parse(attrs.dragdropHandler)(scope)
    sortable = $parse(attrs.dragdropSortable)(scope)
    registerOption 'dragdropEnabled'

    element.addClass(dragdropConfig.containerClass)

    updateEmptyClass = ->
      if items.length == 0
        element.addClass(dragdropConfig.containerEmptyClass)
      else
        element.removeClass(dragdropConfig.containerEmptyClass)

    updateEmptyClass()

    scope.$watchCollection "items", (newItems) ->
      updateEmptyClass()

    # -- Dragdrop item API --------------------------

    scope.dragdrop = {
      type: 'container',
      element: element,
      getIndex: (item) -> items.indexOf(item)
      getItems: -> items,
      updateEmptyClass: updateEmptyClass
      isEnabled: -> scope.dragdropEnabled
      isSortable: -> sortable
      contains: (itemModel) ->
        items.indexOf(itemModel) > -1
      insertItem: (idx, itemModel) ->
        scope.$apply ->
          items.splice(idx, 0, itemModel)
          updateEmptyClass()
      removeItem: (idx) ->
        scope.$apply ->
          items.splice(idx, 1)[0]
          updateEmptyClass()
      onItemMoved: (item, newIdx, oldIdx) ->
        if handler && handler.onItemMoved
          scope.$apply ->
            handler.onItemMoved(item, newIdx, oldIdx)
      onItemRemoved: (item, idx) ->
        if handler && handler.onItemRemoved
          scope.$apply ->
            handler.onItemRemoved(item, idx)
      onItemInserted: (item, idx, drag) ->
        if handler && handler.onItemInserted
          scope.$apply ->
            handler.onItemInserted(item, idx)
    }

    return
# dragdropContainer

