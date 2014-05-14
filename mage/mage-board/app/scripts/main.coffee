"use strict"

deps = ['ngRoute', 'ngAnimate', 'ngResource']
app = angular.module('mageBoard', deps)

app.config ($httpProvider, $routeProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common["X-Requested-With"]

app.controller 'AppController', ($scope) ->
  $scope.loading = false
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

