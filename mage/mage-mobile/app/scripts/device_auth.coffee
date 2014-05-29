"use strict"

module = angular.module('mage.mobile.deviceAuth', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/devices/auth',
      templateUrl: '/views/device_auth.html'
      controller: 'DeviceAuthController'

 
module.controller 'DeviceAuthController', ($rootScope, $scope, $location, DeviceAuthService) ->
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

    DeviceAuthService.auth(params).then(success, failure)
      .finally ->
        $scope.loading = false

