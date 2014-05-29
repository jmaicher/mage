"use strict"

module = angular.module('mage.mobile.auth', [
  'mage.hosts'
])
  
module.config ($routeProvider) ->

  $routeProvider
    .when '/auth',
      templateUrl: '/views/auth.html'
      controller: 'AuthController'


module.controller 'AuthController', ($rootScope, $scope, $location, $route, AuthService, UserAuthService, SessionService) ->
  $rootScope.screenName = 'auth'

  on_success = (user) ->
    SessionService.setUser(user)
    AuthService.redirectBack()

  on_failure = (resp) ->
    if resp.status is 401
      $scope.error = resp.data.message
    else
      $scope.error = "Something went wrong. Please try again."

  $scope.submit = (credentials) ->
    $scope.focused = false
    $scope.error = null
    $scope.authForm.$setPristine(true)
    $scope.loading = true
    UserAuthService.auth(credentials).then(on_success, on_failure)
      .finally -> $scope.loading = false

