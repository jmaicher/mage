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

    $scope.quicktags = [
      { name: 'trash', icon: 'trash' }
      { name: 'refine', icon: 'th' }
      { name: 'discuss', icon: 'comment' }
      { name: 'ready', icon: 'ok' }
    ]

    return


app.directive 'quicktagMenu', () ->
  restrict: 'E'
  transclude: true
  templateUrl: '/views/quicktag-menu.html'
  link: ($scope, $element, attrs) ->
    $element.find('a.quicktag-menu-trigger').on 'pointerdown pointerup', (evt) ->
      switch evt.type
        when "pointerdown", "mousedown"
          $scope.$apply -> $scope.opened = true
        when "pointerup", "mouseup"
          $scope.$apply -> $scope.opened = false
      return true

  controller: ($scope) ->
    $scope.opened = false


app.directive 'quicktag', () ->
  restrict: 'E'
  replace: true
  scope:
    item: '='
    quicktag: '='
  templateUrl: '/views/quicktag.html'
  link: ($scope, $element, attrs) ->
    $element.find('a').on 'pointerup mouseup', ->
      $scope.$apply -> $scope.toggle()
  controller: ($scope, $timeout, $http, BacklogItemTaggingMapper) ->
    tag = $scope.quicktag.name
    tagging = $scope.item.find_tagging(tag)
    $scope.has_tag = !!tagging
    $scope.enabled = true

    $scope.toggle = ->
      $scope.enabled = false
      
      unless $scope.has_tag
        url = "http://#{window.location.hostname}:3000/api/backlog_items/#{$scope.item.id}/taggings"
        $http.post(url, {
          tag: {
            name: tag
          }
        }).then (resp) ->
          tagging = BacklogItemTaggingMapper.from_json(resp.data)
          $scope.enabled = true
          $scope.has_tag = true
      else
        url = "http://#{window.location.hostname}:3000/api/backlog_items/#{$scope.item.id}/taggings/#{tagging.id}"
        $http(url: url, method: 'DELETE')
          .then ->
            $scope.enabled = true
            $scope.has_tag = false

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
      drag_min_distance: 15,
      hold_threshold: 15,
      tap: false,
      swipe: false,
      pinch: false,
    }

    lastX = undefined
    lastY = undefined
    lastRotation = undefined
  
    gestures.on 'touch drag transform', (evt) ->
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

