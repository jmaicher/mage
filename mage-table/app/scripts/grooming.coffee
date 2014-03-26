"use strict"

app = angular.module('mageTable')

app.controller 'GroomingController', ($scope, backlog) ->
  $scope.backlog = backlog


app.directive 'surface', () ->
  restrict: 'E'
  scope:
    backlog: '='
  transclude: true
  compile: (tElement, attrs, transclude) ->
    ($scope, $element) ->
      transclude($scope, (clone) -> tElement.append(clone))
      $element.addClass 'surface'

  controller: ($scope, $window, Random)->
    zIndexFront = 0
    $scope.$on 'backlogItem:bringToFront?', (evt, item) ->
      $scope.$broadcast 'backlogItem:bringToFront!', item, ++zIndexFront
  
    rand_pos = ->
      # TODO: Use element dimensions, but not set?
      x = Random.getRandomInt(0, $window.innerWidth - 300)
      y = Random.getRandomInt(0, $window.innerHeight - 180)
      [x, y]

    rand_rot = -> Random.getRandomInt(-5, 5)

    $scope.backlogItems = _.map($scope.backlog.items, (item) ->
      [x, y] = rand_pos()
      r = rand_rot()

      x: x
      y: y
      rotation: r
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
      transform($element, x, y, r)
 
  controller: ($scope, $rootScope, $element) ->
    item = $scope.item
    isFront = false

    @getX = -> $scope.item.x
    @getY = -> $scope.item.y
    @setX = (x) -> $scope.item.x = x
    @setY = (y) -> $scope.item.y = y
    @getRotation = -> $scope.item.rotation
    @setRotation = (r) -> $scope.item.rotation = r
    @bringToFront = ->
      return if isFront
      $scope.$emit 'backlogItem:bringToFront?', item
    
    $scope.$on 'backlogItem:bringToFront!', (evt, item, zIndex) ->
      isFront = item == $scope.item
      $element.css 'z-index': zIndex if isFront

    return


app.directive 'transformable', () ->
  restrict: 'A'
  require: 'backlogItem'
  link: ($scope, $element, attrs, backlogItemCtrl) ->
    el = $element[0]
    gestures = Hammer el, {
      transform_always_block: true,
      drag_block_horizontal: true,
      drag_block_vertical: true,
      drag_min_distance: 0
    }

    lastX = undefined
    lastY = undefined
    lastRotation = undefined
  
    gestures.on 'touch dragstart drag dragend transformstart transform transformend', (evt) ->
      switch evt.type
        when 'touch'
          lastX = backlogItemCtrl.getX()
          lastY = backlogItemCtrl.getY()
          lastRotation = backlogItemCtrl.getRotation()
          backlogItemCtrl.bringToFront()
        when 'drag'
          $scope.$apply ->
            backlogItemCtrl.setX lastX + evt.gesture.deltaX
            backlogItemCtrl.setY lastY + evt.gesture.deltaY
        when 'transform'
          $scope.$apply ->
            backlogItemCtrl.setRotation lastRotation + evt.gesture.rotation
          


# -- Helper functions -----------------------------------

transform = ($el, x, y, rotation) ->
  trans_fn = "translate(#{x}px, #{y}px) rotate(#{rotation}deg)"
  $el.css
    '-webkit-transform': trans_fn
    '-moz-transform': trans_fn
    'transform': trans_fn

