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
  templateUrl: '/views/backlog_item.html'
  scope:
    model: '='
  link: ($scope, $element, attrs, ctrl) ->
    $element.addClass 'backlog-item'

    x = attrs.x || 0
    y = attrs.y || 0
    rotation = attrs.rotation || 0
    
    transform($element, x, y, rotation)


# -- Helper functions -----------------------------------

transform = ($el, x, y, rotation) ->
  trans_fn = "translate(#{x}px, #{y}px) rotate(#{rotation}deg)"
  $el.css
    '-webkit-transform': trans_fn
    '-moz-transform': trans_fn
    'transform': trans_fn

