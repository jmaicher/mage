"use strict"

module = angular.module('mage.mobile.deviceAuth', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/device-auth',
      templateUrl: '/views/device_auth/index.html'
      controller: 'DeviceAuthController'


module.service 'DeviceAuth', ($q, $http, Hosts) ->
  
  auth = (params) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/devices/sessions"
    
    success = (resp) -> dfd.resolve(resp.data)
    failure = (resp) -> dfd.reject(resp.status, resp.data)

    $http.post(url, params).then(success, failure)

    dfd.promise

  return {
    auth: auth
  }

 
module.controller 'DeviceAuthController', ($rootScope, $scope, $location, DeviceAuth) ->
  $rootScope.screenName = 'device-auth'

  success = ->
    $scope.loading = false
    $location.path '/'

  failure = (status, errors) ->
    $scope.loading = false
    if status is 400
      $scope.errors = {}
      $scope.errors.pin = 'Invalid authentication pin'
    else
      $scope.errors = errors

  $scope.submit = ->
    $scope.errors = null
    $scope.deviceAuthForm.$setPristine(true)
    $scope.loading = true

    params = {
      pin: $scope.pin,
      device: {
        name: $scope.name
      }
    }

    DeviceAuth.auth(params).then(success, failure)
      .finally ->
        $scope.loading = false

