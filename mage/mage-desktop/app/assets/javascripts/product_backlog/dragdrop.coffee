#= require_tree ./dragdrop

deps = [
  'mage.desktop.product_backlog.dragdrop.container',
  'mage.desktop.product_backlog.dragdrop.item'
]
module = angular.module('mage.desktop.product_backlog.dragdrop', deps)

module.constant 'dragdropConfig', {
  hiddenClass: 'dragdrop-hidden',
  dragElementClass: 'dragdrop-drag-element'
  placeHolderClass: 'dragdrop-placeholder'
  itemClass: 'dragdrop-item'
  containerClass: 'dragdrop-container'
  dropContainerClass: 'dragdrop-drop-container'
  containerEmptyClass: 'dragdrop-container-empty'
}

