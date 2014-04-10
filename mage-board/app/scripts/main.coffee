"use strict"

deps = ['ngRoute', 'ngAnimate', 'ngResource', 'mage.services']
app = angular.module('mageBoard', deps)

app.config (MageReactiveProvider) ->
  MageReactiveProvider.setUrl "http://#{window.location.hostname}:9000/echo"

app.config ($httpProvider, $routeProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common["X-Requested-With"]

app.run (MageReactive) ->
  MageReactive.connect().then ->
    MageReactive.publish { foo: "bar" }

app.controller 'AppController', ($scope) ->
  $scope.loading = false
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

