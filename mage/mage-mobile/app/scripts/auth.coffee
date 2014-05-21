"use strict"

module = angular.module('mage.mobile.auth', [
  'mage.hosts'
])
  
module.config ($routeProvider) ->

  $routeProvider
    .when '/auth',
      templateUrl: '/views/auth.html'
      controller: 'AuthController'

module.service 'UserAuth', ($q, $http, Hosts) ->

  auth = (credentials) ->
    dfd = $q.defer()

    on_success = (resp) ->
      user = resp.data
      dfd.resolve(user)

    on_failure = (resp) ->
      dfd.reject(resp)

    $http.post("#{Hosts.api}/sessions", credentials)
      .then on_success, on_failure

    dfd.promise

  return {
    auth: auth
  }


module.controller 'AuthController', ($rootScope, $scope, $location, $route, UserAuth, SessionService) ->
  $rootScope.screenName = 'auth'

  on_success = (user) ->
    SessionService.setUser(user)
    redirect_url = $route.current.params.redirect_to ? '/'
    $location.path(redirect_url)

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
    UserAuth.auth(credentials).then(on_success, on_failure)
      .finally -> $scope.loading = false

