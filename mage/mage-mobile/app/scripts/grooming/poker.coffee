"use strict"

poker = angular.module('mage.mobile.grooming.poker', [])

poker.config ($routeProvider) ->
  $routeProvider
    .when '/grooming/:id/poker/:poker_id',
      templateUrl: '/views/grooming/poker.html'
      controller: 'grooming.PokerController'

poker.controller 'grooming.PokerController', ($scope) ->
  console.log 'Lets poker!'

