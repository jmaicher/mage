"use strict"

module = angular.module('mage.table.auth', [
  'mage.hosts',
  'mage.session'
])

module.config ($routeProvider) ->

  $routeProvider
    .when '/auth',
      templateUrl: '/views/auth.html'
      controller: 'mage.table.AuthController'
      resolve:
        pin: (DeviceAuthService, SessionService) ->
          DeviceAuthService.requestAuthPin(SessionService.getUUID())
        reactiveAuth: (MageReactive, SessionService) ->
          MageReactive.connect('/devices/auth', uuid: SessionService.getUUID())


module.service 'DeviceAuthService', ($q, $http, Hosts) ->

  requestAuthPin = (uuid) ->
    dfd = $q.defer()

    on_success = (resp) ->
      dfd.resolve(resp.data.pin)

    on_error = ->
      dfd.reject

    $http.post("#{Hosts.api}/devices/sessions/pins", {
      uuid: uuid
    }).then on_success, on_error

    dfd.promise

  return {
    requestAuthPin: requestAuthPin
  }


module.controller 'mage.table.AuthController', ($scope, $route, $location, SessionService, pin, reactiveAuth) ->
  $scope.pin = pin

  reactiveAuth.once 'device.authenticated', (device) ->
    reactiveAuth.disconnect()
    $scope.$apply ->
      SessionService.setDevice(device)
      redirect_url = $route.current.params.redirect_to ? '/'
      $location.path(redirect_url)

