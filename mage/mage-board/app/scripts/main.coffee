"use strict"

deps = [
  'ngRoute', 'ngAnimate', 'ngResource',
  'mage.utils', 'mage.hosts', 'mage.auth', 'mage.reactive', 'mage.meetings',
  'mage.board.auth', 'mage.board.home', 'mage.board.dashboard', 'mage.board.meetings'
]
app = angular.module('mage.board', deps)

app.config (AuthServiceProvider) ->
  AuthServiceProvider.setAuthPath('/auth')

app.run ($rootScope) ->
  $rootScope.keyup = (evt) ->
    $rootScope.$broadcast "keyup", evt

  window.onresize = (evt) ->
    $rootScope.$broadcast "windowResize", evt

app.controller 'AppController', ($scope) ->
  $scope.loading = false
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

