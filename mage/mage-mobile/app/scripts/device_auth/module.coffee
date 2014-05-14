"use strict"

module = angular.module('mage.mobile.deviceAuth', [])

module.config ($routeProvider) ->
  $routeProvider
    .when '/device-auth',
      templateUrl: '/views/device_auth/index.html'
      controller: 'DeviceAuthController'


module.service 'DeviceAuth', ($q, $http, Hosts) ->
  
  auth = (pin) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/devices/sessions"
    
    success = (resp) -> dfd.resolve(resp.data)
    failure = (resp) -> dfd.reject(resp.status)

    $http.post(url, {
      pin: pin
    }).then(success, failure)

    dfd.promise

  return {
    auth: auth
  }

 
module.controller 'DeviceAuthController', ($scope, $location, DeviceAuth) ->
  
  success = ->
    $scope.loading = false
    $location.path '/'

  failure = (status) ->
    $scope.loading = false
    $scope.error = 'Invalid authentication pin'

  $scope.submit = (pin) ->
    $scope.error = null
    $scope.deviceAuthForm.$setPristine(true)
    $scope.loading = true
    DeviceAuth.auth(pin).then(success, failure)

