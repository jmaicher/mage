"use strict"

module = angular.module('mage.mobile.meetings.poker', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:id/poker/:poker_id',
      templateUrl: '/views/meetings/poker.html'
      controller: 'meetings.PokerController'

module.controller 'meetings.PokerController', ($rootScope, $scope) ->
  $rootScope.screenName = 'poker'
  # 1, 2, 3, 5, 8, 13, 20, 40, and 100
  options = [0, 1, 3, 5, 8, 13, 20, 40, 100].map (value, idx) ->
    id: idx
    value: value.toString()

  currentIndex = currentOption = undefined
  gotoOption = (idx) ->
    currentIndex = $scope.currentIndex = idx
    currentOption = $scope.currentOption = options[idx]
  
  # Go to zero by default!
  gotoOption(0)

  $scope.next = ->
    if(currentIndex == options.length - 1) then gotoOption(0)
    else gotoOption(currentIndex + 1)

  $scope.prev = ->
    if(currentIndex == 0) then gotoOption(options.length - 1)
    else gotoOption(currentIndex - 1)

