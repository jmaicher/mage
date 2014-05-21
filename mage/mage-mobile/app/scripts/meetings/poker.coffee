"use strict"

module = angular.module('mage.mobile.meetings.poker', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/meetings/:id/poker/:poker_id',
      templateUrl: '/views/meetings/poker.html'
      controller: 'meetings.PokerController'

module.controller 'meetings.PokerController', ($scope) ->
  console.log 'Lets poker!'

