"use strict"

deps = ['ngRoute', 'ngAnimate', 'ngResource', 'mage.services']
app = angular.module('mageTable', deps)

app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      redirectTo: '/grooming'
    .when '/grooming',
      templateUrl: '/views/grooming.html'
      controller: 'GroomingController'
      resolve:
        backlog: (BacklogService) ->
          BacklogService.get()


app.controller 'AppController', ($scope) ->
  $scope.loading = false
  load = -> $scope.loading = true
  ready = -> $scope.loading = false

  $scope.$on '$routeChangeStart', -> load()
  $scope.$on '$routeChangeError', -> ready()
  $scope.$on '$routeChangeSuccess', -> ready()

