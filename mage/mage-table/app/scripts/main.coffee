"use strict"

deps = [
  'ngRoute', 'ngAnimate', 'ngResource',
  'mage.utils', 'mage.hosts', 'mage.auth', 'mage.reactive',
  'mage.services', 'mage.table.auth'
]
app = angular.module('mageTable', deps)

app.config ($httpProvider, $routeProvider, AuthConfigProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common["X-Requested-With"]

  $routeProvider
    .when '/',
      redirectTo: '/grooming'
    .when '/grooming',
      templateUrl: '/views/grooming.html'
      controller: 'GroomingController'
      resolve:
        backlog: (BacklogService) ->
          BacklogService.get()

  AuthConfigProvider.setSignInPath('/auth')

app.controller 'AppController', ($scope) ->
  $scope.loading = true
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

