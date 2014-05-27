"use strict"

deps = [
  'ngRoute', 'ngAnimate', 'ngResource',
  'mage.utils', 'mage.hosts', 'mage.auth', 'mage.reactive', 'mage.meetings',
  'mage.board.auth', 'mage.board.home', 'mage.board.meetings'
]
app = angular.module('mage.board', deps)

app.config (AuthConfigProvider) ->
  AuthConfigProvider.setSignInPath('/auth')

app.controller 'AppController', ($scope) ->
  $scope.loading = false
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

