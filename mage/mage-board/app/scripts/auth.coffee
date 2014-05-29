"use strict"

deps = [
  'mage.hosts', 'mage.session', 'mage.auth'
]
module = angular.module('mage.board.auth', deps)


# -- Routes ------------------------------------------------------------

module.config ($routeProvider) ->

  $routeProvider
    .when '/auth',
      templateUrl: '/views/auth.html'
      controller: 'AuthController'
      resolve:
        pin: (DeviceAuthService, SessionService) ->
          DeviceAuthService.requestAuthPin(SessionService.getUUID())
        reactiveAuth: (MageReactive, SessionService) ->
          MageReactive.connect('/devices/auth', uuid: SessionService.getUUID())


# -- Controllers -------------------------------------------------------

module.controller 'AuthController', ($scope, $route, $location, AuthService, SessionService, pin, reactiveAuth) ->
  $scope.pin = pin

  reactiveAuth.once 'device.authenticated', (device) ->
    reactiveAuth.disconnect()
    $scope.$apply ->
      SessionService.setDevice(device)
      AuthService.redirectBack()

