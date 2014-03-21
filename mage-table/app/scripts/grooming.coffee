"use strict"

app = angular.module('mageTable')

app.controller 'GroomingController', ($scope, $window, Random, backlog) ->
  rand_pos = ->
    x = Random.getRandomInt(0, $window.innerWidth - 300)
    y = Random.getRandomInt(0, $window.innerHeight - 180)
    [x, y]

  $scope.backlogItems = _.map(backlog.items, (item) ->
    [x, y] = rand_pos()

    x: x
    y: y
    rotation: 0
    model: item
  )
  

app.directive 'backlogItem', () ->
  restrict: 'E'
  priority: 1
  scope:
    item: '='
  templateUrl: '/views/backlog_item.html'
  link: ($scope, $element, attrs, ctrl) ->
    $element.addClass 'backlog-item'

    item = $scope.item

    x = item.x || (item.x = 0)
    y = item.y || (item.y = 0)
    rotation = item.rotation || (item.rotation = 0)
    # initial transform
    transform($element, x, y, rotation)

    $scope.$watchCollection '[item.x, item.y, item.rotation]', (newValues, oldValues) ->
      [x, y, r] = newValues
      transform($element, x, y, rotation)
 
  controller: ($scope, $rootScope, $element) ->
    item = $scope.item
    isFront = false

    @getX = -> $scope.item.x
    @getY = -> $scope.item.y
    @setX = (x) -> $scope.item.x = x
    @setY = (y) -> $scope.item.y = y
    @getRotation = $scope.item.rotation
    @setRotation = (r) -> $scope.item.rotation = r
    @bringToFront = ->
      return if isFront
      $rootScope.$broadcast 'backlogItem:bringToFront', item
    
    $rootScope.$on 'backlogItem:bringToFront', (evt, item) ->
      isFront = item == $scope.item
      zIndex = if isFront then 1000 else 500
      $element.css 'z-index': zIndex

    return

app.directive 'transformable', () ->
  restrict: 'A'
  require: 'backlogItem'
  link: ($scope, $element, attrs, backlogItemCtrl) ->
    gestures = Hammer $element[0], {
      transform_always_block: true,
      drag_block_horizontal: true,
      drag_block_vertical: true,
      drag_min_distance: 0
    }

    lastX = backlogItemCtrl.getX()
    lastY = backlogItemCtrl.getY()
    #rotation = backlogItemCtrl.getRotation()
  
    gestures.on 'hold touch dragstart drag dragend transform', (evt) ->
      switch evt.type
        when 'hold' then
        when 'touch'
          backlogItemCtrl.bringToFront()
        when 'dragstart' then
        when 'drag'
          $scope.$apply ->
            backlogItemCtrl.setX lastX + evt.gesture.deltaX
            backlogItemCtrl.setY lastY + evt.gesture.deltaY
        when 'dragend'
          lastX = backlogItemCtrl.getX()
          lastY = backlogItemCtrl.getY()
        when 'transform' then


# -- Helper functions -----------------------------------

transform = ($el, x, y, rotation) ->
  trans_fn = "translate(#{x}px, #{y}px) rotate(#{rotation}deg)"
  $el.css
    '-webkit-transform': trans_fn
    '-moz-transform': trans_fn
    'transform': trans_fn

