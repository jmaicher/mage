"use strict"

module = angular.module('mage.table.meeting', ['mage.table.quicktags'])

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:id',
      templateUrl: '/views/meeting.html'
      controller: 'MeetingController'
      resolve:
        meeting: ($rootScope, $route, MeetingService) ->
          if $rootScope.meeting
            meeting = $rootScope.meeting
            # remove global tmp variable
            delete $rootScope.meeting
            meeting
          else
            id = $route.current.params['id']
            MeetingService.get(id)
        backlog: (BacklogService) ->
          BacklogService.get()

 
module.service 'MeetingService', ($q, $http, Hosts) ->

  get = (id) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/meetings/#{id}"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, reason: resp.data)

    $http.get(url).then success, failure
    
    return dfd.promise
  # get
  
  create = ->
    dfd = $q.defer()
    url = "#{Hosts.api}/meetings"

    success = (resp) ->
      dfd.resolve(resp.data)

    failure = (resp) ->
      dfd.reject(status: resp.status, errors: resp.data)

    $http.post(url).then success, failure
    
    return dfd.promise
  # create
  
  return {
    get: get
    create: create
  }

# MeetingService


module.controller 'MeetingController', ($scope, backlog) ->
  $scope.backlog = backlog

module.directive 'surface', () ->
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


module.service 'Focus', ($window, $q) ->
  $overlay = $('#focus-overlay')
  active = null

  bringToFocus: (item, $element, origin) ->
    return false if !!active

    active = {
      $element: $element
      origin: origin
      isBeginning: true
      isEnding: false
    }

    # define target state
    width = $element.width()
    height = $element.height()
    # r will be defined by animations
    target =
      x: $window.innerWidth / 2 - (width / 2)
      y: $window.innerHeight / 2 - (height / 2)
      scale: 1.5

    initAnimation = new Rekapi(document.body)
    initActor = initAnimation.addActor context: $element[0]
    
    initActor
      .keyframe 0, transform: "translate(#{origin.x}px, #{origin.y}px) rotate(#{origin.rotation}deg) scale(#{origin.scale})"
      .keyframe 1500, {
        transform: "translate(#{target.x}px, #{target.y}px) rotate(#{origin.rotation + 360}deg) scale(#{target.scale})"
      }, 'easeInOutSine'
    
    overlayActor = initAnimation.addActor context: $overlay[0]
    overlayActor
      .keyframe 0, opacity: 0
      .keyframe 1500, opacity: 1

    resumeAnimation = new Rekapi(document.body)
    resumeActor = resumeAnimation.addActor context: $element[0]

    resumeActor
      .keyframe 0, transform: "translate(#{target.x}px, #{target.y}px) rotate(#{origin.rotation}deg) scale(#{target.scale})"
      .keyframe 16000, transform: "translate(#{target.x}px, #{target.y}px) rotate(#{origin.rotation + 360}deg) scale(#{target.scale})"

    $overlay.css 'z-index': 10000, 'display': 'block'
    $element.css 'z-index': 10001

    initAnimation.play(1)
    active.animation = initAnimation

    initAnimation.on 'stop', ->
      active.isBeginning = false
      if not active.isEnding
        resumeAnimation.play()
        active.animation = resumeAnimation

    return {
      isBeginning: -> active.isBeginning
      isPlaying: -> active.animation.isPlaying()
      isEnding: -> active.isEnding
      pause: -> active.animation.pause() unless active.isEnding
      play: -> active.animation.play() unless active.isEnding
    }

  endFocus: ->
    if active.isEnding
      return active.endingPromise

    dfd = $q.defer()
    origin = active.origin
    $element = active.$element
    focusAnimation = active.animation

    active.isEnding = true
    active.endingPromise = dfd.promise

    focusAnimation.stop()

    originAnimation = new Rekapi(document.body)
    itemActor = originAnimation.addActor context: $element[0]
    overlayActor = originAnimation.addActor context: $overlay[0]

    itemActor
      .keyframe 0, transform: $element[0].style['transform']
      .keyframe 1500, {
        transform: "translate(#{origin.x}px, #{origin.y}px) rotate(#{origin.rotation}deg) scale(#{origin.scale})"
      }, 'easeInOutSine'

    overlayActor
       .keyframe 0, opacity: parseFloat($overlay[0].style['opacity'])
       .keyframe 1500, opacity: 0

    active.animation = originAnimation
    originAnimation.play(1)

    originAnimation.on 'stop', ->
      $element.css 'z-index': origin.zIndex
      $overlay.css('display': 'none')
      active = null
      dfd.resolve()

    dfd.promise


module.directive 'backlogItem', () ->
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
 
  controller: ($scope, $rootScope, $element, Focus, $timeout) ->
    item = $scope.item
    isFront = false
    focus = null

    @getX = -> $scope.item.x
    @getY = -> $scope.item.y
    @setX = (x) -> $scope.item.x = x
    @setY = (y) -> $scope.item.y = y
    @getRotation = -> $scope.item.rotation
    @setRotation = (r) -> $scope.item.rotation = r
    @getScale = () -> 1

    @bringToFront = ->
      return if isFront
      $scope.$emit 'backlogItem:bringToFront?', item

    @bringToFocus = ->
      origin = {
        x: @getX(), y: @getY(),
        rotation: @getRotation(),
        scale: @getScale(),
        zIndex: $element.css('z-index')
      }

      focus = Focus.bringToFocus(item, $element, origin)

    @endFocus = ->
      Focus.endFocus().then ->
        focus = null

    @isFocused = -> !!focus
    @isFocusPlaying = -> focus.isPlaying()
    @isFocusBeginning = -> focus.isBeginning()
    @isFocusEnding = -> focus.isEnding()
    @pauseFocus = -> focus.pause()
    @playFocus = -> focus.play()

    @toggleFocusPlayingState = ->
      if focus.isPlaying() then focus.pause()
      else focus.play()

    $scope.$on 'backlogItem:bringToFront!', (evt, item, zIndex) ->
      isFront = item == $scope.item
      $element.css 'z-index': zIndex if isFront

    $scope.quicktags = [
      { name: 'trash', icon: 'trash-o' }
      { name: 'refine', icon: 'sitemap' }
      { name: 'discuss', icon: 'comment' }
      { name: 'ready', icon: 'check' }
    ]

    return


module.directive 'transformable', () ->
  restrict: 'A'
  require: 'backlogItem'
  link: ($scope, $element, attrs, backlogItemCtrl) ->
    el = $element[0]
    gestures = Hammer el, {
      drag_block_horizontal: true,
      drag_block_vertical: true,
      drag_min_distance: 15,
      hold_threshold: 15,
      pinch: false,
      swipe: false,
      tap: true,
      transform_always_block: true,
    }

    lastX = undefined
    lastY = undefined
    lastRotation = undefined

    resetBoxShadow = (duration) ->
      # reset box shadow transition
      $element.css
        'transition': "box-shadow #{duration}s linear"
        'box-shadow': '0 0 5em 1em rgba(0, 0, 0, .5)'
      $element.on 'webkitTransitionEnd', ->
        $element.css 'transition': 'none'

    initScale = 0

    gestures.on 'touch drag transformstart transform transformend tap', (evt) ->
      switch evt.type

        when 'touch'
          break if backlogItemCtrl.isFocused()
          lastX = backlogItemCtrl.getX()
          lastY = backlogItemCtrl.getY()
          lastRotation = backlogItemCtrl.getRotation()
          backlogItemCtrl.bringToFront()

        when 'drag'
          break if backlogItemCtrl.isFocused()
          $scope.$apply ->
            backlogItemCtrl.setX lastX + evt.gesture.deltaX
            backlogItemCtrl.setY lastY + evt.gesture.deltaY

        when 'transformstart'
          initScale = evt.gesture.scale
          if backlogItemCtrl.isFocused() and not (backlogItemCtrl.isFocusBeginning() or backlogItemCtrl.isFocusEnding())
            if backlogItemCtrl.isFocusPlaying()
              backlogItemCtrl.pauseFocus()

        when 'transform'
          if not backlogItemCtrl.isFocused()
            # default behaviour
            
            # rotate
            $scope.$apply ->
              backlogItemCtrl.setRotation lastRotation + evt.gesture.rotation
            
            # focus?
            scale = evt.gesture.scale - initScale
            # increase box shadow
            shadowFactor = 1 + (Math.max(0, scale - 0.5) * 10)
            $element.css
              'transition': "box-shadow none"
              'box-shadow': "0 0 #{shadowFactor + 5}em #{1 + Math.log(shadowFactor * 2)}em rgba(0, 0, 0, .5)"
            
        when 'transformend'
          scale = evt.gesture.scale - initScale

          if not backlogItemCtrl.isFocused()
            if scale > 2
              # we track the id as hammer.js throws an error when we stop the gesture :-(
              bringToFocusTransformId = transform.id
              backlogItemCtrl.bringToFocus()
              resetBoxShadow(4)
            else
              resetBoxShadow(1)
          
          else if backlogItemCtrl.isFocused() and not backlogItemCtrl.isFocusEnding()
            if scale < -0.25
              backlogItemCtrl.endFocus()

        when 'tap'
          if backlogItemCtrl.isFocused() and not (backlogItemCtrl.isFocusBeginning() or backlogItemCtrl.isFocusEnding())
            backlogItemCtrl.toggleFocusPlayingState()

      
      return



# -- Helper functions -----------------------------------

transform = ($el, x, y, rotation) ->
  trans_fn = "translate(#{x}px, #{y}px) rotate(#{rotation}deg)"
  $el.css
    '-webkit-transform': trans_fn
    '-moz-transform': trans_fn
    'transform': trans_fn

